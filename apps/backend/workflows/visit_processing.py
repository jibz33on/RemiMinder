import os
import re

from domain.ports.ai import generate_visit_summary, get_model_name
from domain.ports.cache import get, set
from domain.ports.stt import run_audio_stt_pipeline
from domain.ports.logging import get_logger
from workflows.summary_normalizer_v2 import normalize_v2_summary
from domain.patient_tasks.service import generate_reminders_from_actions, generate_tasks_from_summary
from domain.transcripts.repo import get_transcript_text, save_raw_transcript
from domain.stt2.service import enqueue_stt2_extraction
from domain.summaries.repo import insert_ai_summary_log
from domain.users.repo import get_user_language_preferences, get_user_uuid
from domain.visits.repo import update_visit_with_structured_data

logger = get_logger()


def _get_prompt_version() -> str:
    """
    Feature flag for prompt versioning.
    Defaults to v1 for missing/invalid values.
    """
    version = (os.getenv("AI_SUMMARY_PROMPT_VERSION") or "v1").lower().strip()
    return "v2" if version == "v2" else "v1"


async def run_ai_summary_pipeline(visit_id: str, transcript_id: str, user_id: str) -> str:
    """
    Complete AI summary pipeline for a visit transcript with structured data.

    Args:
        visit_id: The visit identifier
        transcript_id: The transcript identifier
        user_id: The user identifier

    Returns:
        Generated summary text (for backward compatibility)

    Raises:
        Exception: If any step in the pipeline fails
    """
    try:
        logger.info(f"Starting AI summary pipeline for visit {visit_id}, transcript {transcript_id}")

        # Step A: Fetch user's language preferences
        logger.info(f"🔍 [LANGUAGE] Fetching language preferences for user {user_id}")
        try:
            cache_key = f"language_prefs:{user_id}"
            cached = get(cache_key)
            if cached is not None:
                language_prefs = cached
            else:
                language_prefs = await get_user_language_preferences(user_id)
                if language_prefs is not None:
                    set(cache_key, language_prefs, 1800)
            visit_language = language_prefs.get("visit_language", "en") if language_prefs else "en"
            logger.info(f"🔍 [LANGUAGE] Retrieved preferences: {language_prefs}")
            logger.info(f"🔍 [LANGUAGE] Using visit_language='{visit_language}' for AI processing")
        except Exception as e:
            logger.warning(f"🔍 [LANGUAGE] Failed to fetch language preferences for user {user_id}: {e}. Using default 'en'")
            visit_language = "en"

        # Step B: Fetch raw transcript text from DB
        logger.info(f"Fetching transcript text for transcript_id: {transcript_id}")
        raw_text = await get_transcript_text(transcript_id)

        if not raw_text or not raw_text.strip():
            raise ValueError(f"No transcript text found for transcript_id {transcript_id}")

        logger.info(f"Retrieved transcript text (length: {len(raw_text)} chars)")

        # Step C: Generate structured summary using Vertex Gemini
        logger.info(f"Generating AI structured summary for visit {visit_id} in language {visit_language}")
        structured_result = await generate_visit_summary(raw_text, visit_language)

        # Feature-flagged normalization for V2 outputs
        prompt_version = _get_prompt_version()
        if prompt_version == "v2":
            structured_result = normalize_v2_summary(structured_result, visit_language)

        # Extract summary text for backward compatibility
        summary_text = structured_result.get("summary", "")
        logger.info(f"Generated structured summary (length: {len(summary_text)} chars)")

        # Step C: Save structured summary to database
        logger.info(f"Saving structured summary to database for transcript {transcript_id}")
        summary_id = await insert_ai_summary_log(
            transcript_id,
            visit_id,
            user_id,
            summary_text,
            structured_result,
            model_name=get_model_name(),
        )
        logger.info(f"Structured summary saved successfully for visit {visit_id}")
        if summary_id:
            await generate_tasks_from_summary(
                user_id=user_id,
                visit_id=visit_id,
                summary_id=summary_id,
                structured_summary=structured_result,
            )
            await generate_reminders_from_actions(
                user_id=user_id,
                visit_id=visit_id,
                actions=structured_result.get("actions", []),
            )

        # Step D: Update visit with structured data (always after summary generation)
        doctor_name = structured_result.get("doctor_name")
        if not isinstance(doctor_name, str) or not doctor_name.strip():
            # Fallback: extract doctor name from transcript when LLM omits it.
            match = re.search(
                r"(?:Dr\.?|Doctor)\s+([A-Z][a-zA-Z]+(?:\s+[A-Z][a-zA-Z]+){0,3})",
                raw_text or "",
                flags=re.IGNORECASE,
            )
            if match:
                doctor_name = match.group(1).strip()
        specialty = structured_result.get("specialty")
        title = structured_result.get("visit_display_title")
        logger.info(
            "Updating visit metadata: visit_id=%s, doctor_name=%s, specialty=%s, title=%s",
            visit_id,
            doctor_name,
            specialty,
            title,
        )
        await update_visit_with_structured_data(
            visit_id=visit_id,
            doctor_name=doctor_name,
            specialty=specialty,
            title=title,
        )

        # Step E: Return the summary text (for backward compatibility)
        return summary_text

    except Exception as e:
        logger.error(f"AI summary pipeline failed for visit {visit_id}: {str(e)}")
        raise


async def process_audio_visit(visit_id: str, external_auth_id: str) -> None:
    """
    End-to-end audio visit processing:
    GCS audio -> STT -> save raw transcript.
    """
    logger.info(f"Starting audio visit processing for visit_id={visit_id}")

    stt_result = await run_audio_stt_pipeline(visit_id, external_auth_id)
    user_uuid = await get_user_uuid(external_auth_id)

    await save_raw_transcript(
        visit_id=visit_id,
        user_id=user_uuid,
        transcript=stt_result["transcript"],
        confidence=stt_result["confidence"],
        language=stt_result["language"],
        stt_engine=stt_result["stt_engine"],
    )

    try:
        job_id = await enqueue_stt2_extraction(visit_id)
        if job_id:
            logger.info("Queued STT-2 extraction job %s for visit %s", job_id, visit_id)
    except Exception as exc:
        logger.warning("Failed to enqueue STT-2 extraction for visit %s: %s", visit_id, exc)

    logger.info(f"Completed audio visit processing for visit_id={visit_id}")
