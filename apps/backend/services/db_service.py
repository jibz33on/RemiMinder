"""
Minimal Cloud SQL service for audio/image upload lifecycle.
Only contains functions actively used by upload endpoints.
"""

import json
import logging
from typing import Optional, Dict, Any
from fastapi import HTTPException
from .cloud_sql_engine import get_cloud_sql_engine
from sqlalchemy import text

logger = logging.getLogger(__name__)


async def get_user_uuid(firebase_uid: str) -> str:
    """
    Get the Cloud SQL user UUID from Firebase UID.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT id FROM users WHERE firebase_uid = :firebase_uid
            """)

            result = conn.execute(query, {"firebase_uid": firebase_uid})
            row = result.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail=f"User not found for Firebase UID {firebase_uid}")

            return str(row[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error getting user UUID for Firebase UID {firebase_uid}: {e}")
        raise


async def save_raw_transcript(
    visit_id: str,
    user_id: str,
    transcript: str,
    confidence: float | None = None,
    language: str | None = None
) -> str:
    """Save raw STT transcript to visit_transcripts table.

    Returns the transcript_id of the saved record.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            # Update existing record with transcript (only guaranteed columns)
            update_query = text("""
                UPDATE visit_transcripts
                SET transcript_text = :transcript
                WHERE visit_id = :visit_id
            """)

            conn.execute(update_query, {
                "transcript": transcript,
                "visit_id": visit_id
            })

            # Get the transcript_id for the updated record
            select_query = text("""
                SELECT transcript_id FROM visit_transcripts
                WHERE visit_id = :visit_id
            """)

            result = conn.execute(select_query, {"visit_id": visit_id})
            row = result.fetchone()

            if not row:
                raise HTTPException(status_code=404, detail=f"No transcript record found for visit {visit_id}")

            transcript_id = str(row[0])
            conn.commit()
            logger.info(f"Saved transcript for visit {visit_id}: {len(transcript)} characters, transcript_id: {transcript_id}")

            return transcript_id

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error saving transcript for visit {visit_id}: {e}")
        raise


async def get_audio_gcs_url(visit_id: str, user_id: str) -> str:
    """
    Fetch audio_url for a visit from Cloud SQL only.
    No Supabase.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            # Query visit_transcripts table for audio_url
            query = text("""
                SELECT audio_url FROM visit_transcripts
                WHERE visit_id = :visit_id AND user_id = :user_id
            """)

            result = conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
            row = result.fetchone()

            if not row or not row[0]:
                raise HTTPException(status_code=404, detail=f"No audio file found for visit {visit_id}")

            return str(row[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching audio URL for visit {visit_id}: {e}")
        raise


async def ensure_user_exists(firebase_uid: str, email: str) -> bool:
    """
    Ensure a user row exists in Cloud SQL.
    Returns True if created, False if already exists.
    """
    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("SELECT id FROM users WHERE firebase_uid = :firebase_uid"),
            {"firebase_uid": firebase_uid},
        )
        if result.fetchone():
            return False

        conn.execute(
            text("""
                INSERT INTO users (firebase_uid, email, role, is_active)
                VALUES (:firebase_uid, :email, 'user', true)
            """),
            {"firebase_uid": firebase_uid, "email": email},
        )
        return True


async def get_transcript_text(transcript_id: str) -> str:
    """
    Fetch raw transcript text from visit_transcripts table.
    Used by AI pipeline to get text for summarization.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT transcript_text FROM visit_transcripts
                WHERE transcript_id = :transcript_id
            """)

            result = conn.execute(query, {"transcript_id": transcript_id})
            row = result.fetchone()

            if not row or not row[0]:
                raise HTTPException(status_code=404, detail=f"No transcript text found for transcript_id {transcript_id}")

            return str(row[0])

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching transcript text for transcript_id {transcript_id}: {e}")
        raise


async def insert_ai_summary_log(transcript_id: str, visit_id: str, user_id: str, summary_text: str) -> None:
    """
    Insert AI-generated summary into summaries_log table.
    Used by AI pipeline to persist generated summaries.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO summaries_log
                (transcript_id, visit_id, user_id, model_name, summary_text, cost_usd)
                VALUES (:transcript_id, :visit_id, :user_id, :model, :summary, :cost)
            """)

            conn.execute(insert_query, {
                "transcript_id": transcript_id,
                "visit_id": visit_id,
                "user_id": user_id,
                "model": "gemini-1.5-flash",
                "summary": summary_text,
                "cost": 0.001  # Placeholder cost, should be calculated properly
            })

            logger.info(f"Inserted AI summary for transcript {transcript_id}")

    except Exception as e:
        logger.error(f"Error inserting AI summary for transcript {transcript_id}: {e}")
        raise