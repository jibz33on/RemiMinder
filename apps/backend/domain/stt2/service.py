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

logger = get_logger()

STT2_JOB_TYPE = "stt2_extraction"
STT2_PROMPT_VERSION_PLACEHOLDER = "stt2_v0"
STT2_MODEL_PLACEHOLDER = "stt2_placeholder"


def _hash_transcript(text: str) -> str:
    return hashlib.sha256((text or "").encode("utf-8")).hexdigest()


def _placeholder_extraction_output() -> dict:
    return {
        "summary": "",
        "actions": [],
        "doctor_name": "",
        "specialty": "",
        "visit_display_title": "",
        "action_items": [],
        "questions_next_visit": [],
        "key_diagnoses": [],
        "medications": [],
    }


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
    Placeholder STT-2 extraction job. No LLM calls yet.
    """
    summary_row = await get_stt2_summary_row(visit_id)
    if summary_row is None:
        raise RuntimeError(f"STT-2 summary row missing for visit {visit_id}")
    status = summary_row["status"]
    if status == "completed":
        logger.info("STT-2 extraction already completed for visit %s; skipping", visit_id)
        return
    if status == "processing":
        logger.info("STT-2 extraction already in progress for visit %s; skipping", visit_id)
        return

    raw_transcript = await get_raw_stt_transcript_for_visit(visit_id)
    if not raw_transcript:
        raise RuntimeError(f"Raw STT transcript missing for visit {visit_id}")
    current_hash = _hash_transcript(raw_transcript["transcript_text"] or "")
    if summary_row.get("raw_transcript_hash") and summary_row["raw_transcript_hash"] != current_hash:
        logger.warning("STT-2 raw transcript hash mismatch for visit %s; continuing", visit_id)

    processing_info = await mark_stt2_summary_processing(visit_id)
    if not processing_info:
        logger.info("STT-2 processing claim failed for visit %s; skipping", visit_id)
        return

    started = time.monotonic()
    output: dict | None = None
    error_text: str | None = None
    try:
        output = _placeholder_extraction_output()
        await mark_stt2_summary_completed(visit_id, output, current_hash)
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
