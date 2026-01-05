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
) -> None:
    """Save raw STT transcript to visit_transcripts table."""
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

            conn.commit()
            logger.info(f"Saved transcript for visit {visit_id}: {len(transcript)} characters")

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