"""
AI Summary Pipeline Orchestrator.

Coordinates the AI summary generation process:
1. Fetch transcript from DB
2. Generate summary using Vertex Gemini
3. Save summary to DB

This orchestrator contains no LLM code, no SQL strings, and no business logic.
"""

import logging
import os
from services.ai.vertex_gemini_service import generate_visit_summary
from services.ai.summary_normalizer_v2 import normalize_v2_summary
from services.db_service import get_transcript_text, insert_ai_summary_log, update_visit_with_structured_data, get_user_language_preferences

logger = logging.getLogger(__name__)


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
            language_prefs = await get_user_language_preferences(user_id)
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
        await insert_ai_summary_log(transcript_id, visit_id, user_id, summary_text, structured_result)
        logger.info(f"Structured summary saved successfully for visit {visit_id}")

        # Step D: Update visit with structured data (V1 only)
        if prompt_version == "v1":
            logger.info(f"Updating visit {visit_id} with structured data")
            await update_visit_with_structured_data(
                visit_id=visit_id,
                doctor_name=structured_result.get("doctor_name"),
                specialty=structured_result.get("specialty"),
                title=structured_result.get("visit_display_title")
            )
            logger.info(f"Visit {visit_id} updated with structured data")
        else:
            logger.info("Skipping visit metadata update for V2 summaries")

        # Step E: Return the summary text (for backward compatibility)
        return summary_text

    except Exception as e:
        logger.error(f"AI summary pipeline failed for visit {visit_id}: {str(e)}")
        raise
