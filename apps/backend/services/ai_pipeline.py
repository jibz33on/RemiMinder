"""
AI Summary Pipeline Orchestrator.

Coordinates the AI summary generation process:
1. Fetch transcript from DB
2. Generate summary using Vertex Gemini
3. Save summary to DB

This orchestrator contains no LLM code, no SQL strings, and no business logic.
"""

import logging
from services.ai.vertex_gemini_service import generate_visit_summary
from services.db_service import get_transcript_text, insert_ai_summary_log

logger = logging.getLogger(__name__)


async def run_ai_summary_pipeline(visit_id: str, transcript_id: str, user_id: str) -> str:
    """
    Complete AI summary pipeline for a visit transcript.

    Args:
        visit_id: The visit identifier
        transcript_id: The transcript identifier
        user_id: The user identifier

    Returns:
        Generated summary text

    Raises:
        Exception: If any step in the pipeline fails
    """
    try:
        logger.info(f"Starting AI summary pipeline for visit {visit_id}, transcript {transcript_id}")

        # Step A: Fetch raw transcript text from DB
        logger.info(f"Fetching transcript text for transcript_id: {transcript_id}")
        raw_text = await get_transcript_text(transcript_id)

        if not raw_text or not raw_text.strip():
            raise ValueError(f"No transcript text found for transcript_id {transcript_id}")

        logger.info(f"Retrieved transcript text (length: {len(raw_text)} chars)")

        # Step B: Generate summary using Vertex Gemini
        logger.info(f"Generating AI summary for visit {visit_id}")
        summary_text = await generate_visit_summary(raw_text)
        logger.info(f"Generated summary (length: {len(summary_text)} chars)")

        # Step C: Save summary to database
        logger.info(f"Saving summary to database for transcript {transcript_id}")
        await insert_ai_summary_log(transcript_id, visit_id, user_id, summary_text)
        logger.info(f"Summary saved successfully for visit {visit_id}")

        # Step D: Return the summary
        return summary_text

    except Exception as e:
        logger.error(f"AI summary pipeline failed for visit {visit_id}: {str(e)}")
        raise
