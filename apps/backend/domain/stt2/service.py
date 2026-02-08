import hashlib
import time

from domain.ports.jobs import create_job
from domain.ports.logging import get_logger
from domain.stt2.repo import (
    get_raw_stt_transcript_for_visit,
    get_stt2_summary_row,
    insert_stt2_structured_summary,
    insert_stt2_summary_run,
    mark_stt2_summary_completed,
    mark_stt2_summary_failed,
    mark_stt2_summary_processing,
)
from domain.users.repo import get_user_uuid
from domain.visits.repo import get_visit_user_id

logger = get_logger()

STT2_JOB_TYPE = "stt2_extraction"
STT2_PROMPT_VERSION_PLACEHOLDER = "stt2_v0"
STT2_MODEL_PLACEHOLDER = "stt2_placeholder"


def _hash_transcript(text: str) -> str:
    return hashlib.sha256((text or "").encode("utf-8")).hexdigest()




async def enqueue_stt2_extraction(visit_id: str) -> str | None:
    """
    Create pending summary row and STT-2 job when raw transcript exists.
    Returns job_id if created, else None.
    """
    raw_transcript = await get_raw_stt_transcript_for_visit(visit_id)
    if not raw_transcript:
        logger.info("STT-2 enqueue skipped; raw transcript missing for visit %s", visit_id)
        return None

    summary_id = await insert_stt2_structured_summary(
        visit_id=visit_id,
        raw_stt_transcript_id=raw_transcript["id"],
        raw_transcript_hash=_hash_transcript(raw_transcript["transcript_text"] or ""),
        prompt_version=STT2_PROMPT_VERSION_PLACEHOLDER,
        model_name=STT2_MODEL_PLACEHOLDER,
    )
    if not summary_id:
        logger.info("STT-2 enqueue skipped; summary already exists for visit %s", visit_id)
        return None

    job_id = create_job(
        job_type=STT2_JOB_TYPE,
        payload={"visit_id": visit_id},
    )
    return job_id


async def run_stt2_extraction_job(visit_id: str, job_id: str | None = None) -> None:
    """
    Stage 3.2: STT execution + extraction job.
    Performs STT if needed, then extracts structured data.
    Uses UPSERT logic to handle missing rows gracefully.
    """
    summary_row = await get_stt2_summary_row(visit_id)
    if summary_row is not None:
        status = summary_row["status"]
        if status == "completed":
            logger.info("STT-2 extraction already completed for visit %s; skipping", visit_id)
            return
        if status == "processing":
            logger.info("STT-2 extraction already in progress for visit %s; skipping", visit_id)
            return

    # Stage 3.2: Ensure transcript exists (do STT if needed)
    raw_transcript = await get_raw_stt_transcript_for_visit(visit_id)
    if not raw_transcript:
        logger.info("No transcript found for visit %s, performing STT", visit_id)
        await _perform_stt_for_visit(visit_id)

        # Re-fetch transcript after STT
        raw_transcript = await get_raw_stt_transcript_for_visit(visit_id)
        if not raw_transcript:
            raise RuntimeError(f"STT failed for visit {visit_id}")

    current_hash = _hash_transcript(raw_transcript["transcript_text"] or "")
    if summary_row and summary_row.get("raw_transcript_hash") and summary_row["raw_transcript_hash"] != current_hash:
        logger.warning("STT-2 raw transcript hash mismatch for visit %s; continuing", visit_id)

    processing_info = await mark_stt2_summary_processing(
        visit_id,
        raw_transcript["id"],
        current_hash
    )
    if not processing_info:
        logger.info("STT-2 processing claim failed for visit %s; skipping", visit_id)
        return

    started = time.monotonic()
    output: dict | None = None
    final_summary: str | None = None
    error_text: str | None = None
    try:
        from domain.stt2.extraction_service import STT2ExtractionService
        service = STT2ExtractionService()
        transcript_text = raw_transcript["transcript_text"] or ""
        output = service.extract(transcript_text)

        # Stage 3.4: Generate final human-readable summary from structured data
        final_summary = await _generate_final_summary(visit_id, output)

        await mark_stt2_summary_completed(
            visit_id,
            output,
            current_hash,
            raw_transcript["id"],
            processing_info["prompt_version"],
            processing_info["model_name"]
        )
        try:
            from domain.downstream.summary_consumer_service import process_downstream_for_visit

            await process_downstream_for_visit(visit_id)
        except Exception as downstream_exc:
            logger.warning(
                "STT-2 downstream processing failed for visit %s: %s",
                visit_id,
                downstream_exc,
            )
    except Exception as exc:
        error_text = str(exc)
        await mark_stt2_summary_failed(visit_id, error_text)
        raise
    finally:
        await insert_stt2_summary_run(
            visit_id=visit_id,
            raw_stt_transcript_id=processing_info["raw_stt_transcript_id"],
            job_id=job_id,
            prompt_version=processing_info["prompt_version"],
            model_name=processing_info["model_name"],
            status="completed" if error_text is None else "failed",
            output_json=output,
            error_text=error_text,
            latency_ms=int((time.monotonic() - started) * 1000),
            tokens_in=None,
            tokens_out=None,
            cost_usd=0.0,
        )


async def _perform_stt_for_visit(visit_id: str) -> None:
    """Stage 3.2: Perform STT for a visit if audio exists but no transcript."""
    # Get user_id (external_auth_id) from visit
    from domain.visits.repo import get_visit_user_id
    from workflows.visit_processing import run_audio_stt_pipeline, save_raw_transcript

    external_auth_id = await get_visit_user_id(visit_id)
    if not external_auth_id:
        raise RuntimeError(f"User not found for visit {visit_id}")

    # Resolve user UUID from external auth ID
    user_uuid = await get_user_uuid(external_auth_id)
    logger.info("[STT2] Resolved user UUID %s for external_auth_id %s", user_uuid, external_auth_id)

    logger.info("Performing STT for visit %s", visit_id)
    stt_result = await run_audio_stt_pipeline(visit_id, external_auth_id)

    await save_raw_transcript(
        visit_id=visit_id,
        user_id=user_uuid,  # Use resolved UUID
        transcript=stt_result["transcript"],
        confidence=stt_result["confidence"],
        language=stt_result["language"],
        stt_engine=stt_result["stt_engine"],
    )
    logger.info("STT completed for visit %s", visit_id)


async def _generate_final_summary(visit_id: str, structured_data: dict) -> str:
    """Stage 3.4: Generate final human-readable summary from structured data."""
    from infra.llm.gemini_client import GeminiClient

    # Create prompt for final summarization
    prompt = _build_final_summary_prompt(structured_data)

    # Call LLM
    client = GeminiClient()
    response_text = client.generate_text(prompt=prompt, temperature=0.0)

    final_summary = (response_text or "").strip()
    if not final_summary:
        raise RuntimeError("LLM returned empty summary")

    # Persist to visits.summary (optional - commented out to avoid schema changes)
    # await _update_visit_with_final_summary(visit_id, final_summary)

    logger.info("Generated final summary for visit %s (%d chars)", visit_id, len(final_summary))
    return final_summary


def _build_final_summary_prompt(structured_data: dict) -> str:
    """Build prompt for final summary generation from structured data."""
    summary = structured_data.get("summary", "")
    actions = structured_data.get("actions", [])
    doctor_name = structured_data.get("doctor_name", "")
    specialty = structured_data.get("specialty", "")
    visit_title = structured_data.get("visit_display_title", "")
    medications = structured_data.get("medications", [])

    prompt = f"""You are a clinical assistant writing a patient-friendly visit summary.

Based on the following structured visit data, write a concise, clear summary that a patient can easily understand:

STRUCTURED DATA:
- Visit Title: {visit_title}
- Doctor: {doctor_name}
- Specialty: {specialty}
- Summary: {summary}
- Key Actions: {', '.join(actions) if actions else 'None specified'}
- Medications: {', '.join(medications) if medications else 'None prescribed'}

Write a natural, patient-friendly paragraph summarizing this visit. Focus on what happened, what the patient should do next, and any important medical information.

Keep it to 2-3 sentences maximum. Use simple language."""

    return prompt


async def _update_visit_with_final_summary(visit_id: str, summary: str) -> None:
    """Update visits table with final summary."""
    from sqlalchemy import text
    from infra.db.cloud_sql_engine import get_cloud_sql_engine

    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        conn.execute(
            text("""
                UPDATE visits
                SET summary = :summary
                WHERE id = :visit_id
            """),
            {"visit_id": visit_id, "summary": summary},
        )
