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
from .ai.vertex_gemini_service import GEMINI_MODEL

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


async def insert_ai_summary_log(transcript_id: str, visit_id: str, user_id: str, summary_text: str, structured_data: dict = None) -> None:
    """
    Insert AI-generated summary into summaries_log table with structured data.
    Used by AI pipeline to persist generated summaries.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO summaries_log
                (transcript_id, visit_id, user_id, model_name, summary_text, structured_data_json, cost_usd)
                VALUES (:transcript_id, :visit_id, :user_id, :model, :summary, :structured_data, :cost)
            """)

            # Convert structured_data dict to JSON string if provided
            structured_data_json = None
            if structured_data is not None:
                structured_data_json = json.dumps(structured_data)

            conn.execute(insert_query, {
                "transcript_id": transcript_id,
                "visit_id": visit_id,
                "user_id": user_id,
                "model": GEMINI_MODEL,  # Updated to use structured model
                "summary": summary_text,
                "structured_data": structured_data_json,  # JSON string for JSONB column
                "cost": 0.001  # Placeholder cost, should be calculated properly
            })

            logger.info(f"Inserted AI summary with structured data for transcript {transcript_id}")

    except Exception as e:
        logger.error(f"Error inserting AI summary for transcript {transcript_id}: {e}")
        raise


async def update_visit_with_structured_data(visit_id: str, doctor_name: str = None, specialty: str = None, title: str = None) -> None:
    """
    Update visit table with structured data extracted from AI summary.
    Only updates fields that are provided and not None.
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            # Build dynamic update query based on provided fields
            update_fields = []
            update_values = {"visit_id": visit_id}

            if doctor_name is not None:
                update_fields.append("doctor = :doctor")
                update_values["doctor"] = doctor_name

            if specialty is not None:
                update_fields.append("specialty = :specialty")
                update_values["specialty"] = specialty

            if title is not None:
                update_fields.append("title = :title")
                update_values["title"] = title

            if not update_fields:
                logger.info(f"No structured data fields to update for visit {visit_id}")
                return

            update_query = text(f"""
                UPDATE visits
                SET {', '.join(update_fields)}
                WHERE id = :visit_id
            """)

            conn.execute(update_query, update_values)
            logger.info(f"Updated visit {visit_id} with structured data: {list(update_values.keys())}")

    except Exception as e:
        logger.error(f"Error updating visit {visit_id} with structured data: {e}")
        raise


async def delete_user_summary(summary_id: str, user_id: str) -> bool:
    """
    Delete a summary from summaries_log table.
    Only allows deletion if the summary belongs to the specified user.

    Args:
        summary_id: The UUID of the summary to delete
        user_id: The UUID of the user (to verify ownership)

    Returns:
        bool: True if summary was deleted, False if not found or not owned by user

    Raises:
        Exception: If database operation fails
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            # Delete query that checks ownership
            delete_query = text("""
                DELETE FROM summaries_log
                WHERE id = :summary_id AND user_id = :user_id
            """)

            result = conn.execute(delete_query, {
                "summary_id": summary_id,
                "user_id": user_id,
            })

            deleted_count = result.rowcount
            logger.info(f"Deleted {deleted_count} summary rows for summary_id={summary_id}, user_id={user_id}")

            return deleted_count > 0

    except Exception as e:
        logger.error(f"Error deleting summary {summary_id} for user {user_id}: {e}")
        raise


async def get_latest_ai_summary_for_visit(visit_id: str, user_id: str) -> Optional[str]:
    """
    Get the latest AI-generated summary for a visit from summaries_log table.
    Returns summary_text if exists, None if not found.
    Used by visit summary API to fetch processed summaries.
    """
    try:
        logger.info(f"Querying summaries_log for visit_id={visit_id}, user_id={user_id}")

        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT summary_text, created_at FROM summaries_log
                WHERE visit_id = :visit_id AND user_id = :user_id
                ORDER BY created_at DESC
                LIMIT 1
            """)

            result = conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
            row = result.fetchone()

            if row and row[0]:
                logger.info(f"Found summary for visit_id={visit_id}, user_id={user_id}: created_at={row[1]}")
                return str(row[0])
            else:
                logger.info(f"No summary found for visit_id={visit_id}, user_id={user_id}")

            return None

    except Exception as e:
        logger.error(f"Error fetching AI summary for visit {visit_id}: {e}")
        raise


async def get_user_summaries(user_uuid: str) -> list[dict]:
    """
    Get all summaries for a user by joining summaries_log and visits tables.
    Returns list of summary objects with visit metadata, ordered by newest first.
    """
    try:
        logger.info(f"Fetching summaries for user_uuid={user_uuid}")

        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT
                    s.id AS summary_id,
                    s.visit_id,
                    s.created_at AS summary_created_at,
                    s.model_name,
                    s.summary_text,
                    v.doctor AS doctor_name,
                    v.specialty AS specialty,
                    s.created_at AS visit_date
                FROM summaries_log s
                JOIN visits v ON v.id = s.visit_id
                WHERE s.user_id = :user_uuid
                ORDER BY s.created_at DESC;
            """)

            result = conn.execute(query, {"user_uuid": user_uuid})
            rows = result.fetchall()

            summaries = []
            for row in rows:
                summary_id, visit_id, summary_created_at, model_name, summary_text, doctor_name, specialty, visit_date = row

                # Truncate summary_text to ~160 characters for preview
                summary_preview = summary_text[:160] + "..." if len(summary_text) > 160 else summary_text

                summaries.append({
                    "summary_id": str(summary_id),
                    "visit_id": str(visit_id),
                    "doctor_name": doctor_name,
                    "specialty": specialty,
                    "visit_date": str(visit_date) if visit_date else None,
                    "summary_created_at": str(summary_created_at),
                    "summary_preview": summary_preview,
                    "model_name": model_name,
                })

            logger.info(f"Found {len(summaries)} summaries for user_uuid={user_uuid}")
            return summaries

    except Exception as e:
        logger.error(f"Error fetching user summaries for user_uuid={user_uuid}: {e}")
        raise


async def get_user_language_preferences(user_uuid: str) -> dict:
    """
    Get user's language preferences.

    Returns:
    {
      "app_language": "en",
      "visit_language": "en"
    }
    """
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT app_language, visit_language
                FROM users
                WHERE id = :user_uuid
            """)

            result = conn.execute(query, {"user_uuid": user_uuid})
            row = result.fetchone()

            logger.info(f"🔍 [DB] Language preferences query for user_uuid={user_uuid} returned row: {row}")

            if not row:
                logger.warning(f"🔍 [DB] User not found for language preferences: {user_uuid}")
                return None

            # Handle both tuple and Row objects safely
            if hasattr(row, '_mapping'):
                # SQLAlchemy Row object with column names
                app_language = row._mapping.get('app_language', 'en')
                visit_language = row._mapping.get('visit_language', 'en')
                logger.info(f"🔍 [DB] Using Row mapping: app_language={app_language}, visit_language={visit_language}")
            else:
                # Tuple unpacking
                app_language, visit_language = row
                logger.info(f"🔍 [DB] Using tuple unpacking: app_language={app_language}, visit_language={visit_language}")

            preferences = {
                "app_language": app_language or 'en',
                "visit_language": visit_language or 'en'
            }

            logger.info(f"🔍 [DB] Final language preferences for user_uuid={user_uuid}: {preferences}")
            return preferences

    except Exception as e:
        logger.error(f"Error getting language preferences for user_uuid={user_uuid}: {e}")
        raise


async def update_user_language_preferences(user_uuid: str, app_language: str, visit_language: str) -> bool:
    """
    Update user's language preferences.

    Returns:
        True if update was successful, False if user not found
    """
    try:
        # Simple validation
        if not app_language or not visit_language:
            raise ValueError("App language and visit language are required")

        if len(app_language) > 10 or len(visit_language) > 10:
            raise ValueError("Language codes must be 10 characters or less")

        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            query = text("""
                UPDATE users
                SET app_language = :app_language,
                    visit_language = :visit_language,
                    updated_at = now()
                WHERE id = :user_uuid
            """)

            result = conn.execute(query, {
                "user_uuid": user_uuid,
                "app_language": app_language,
                "visit_language": visit_language
            })

            success = result.rowcount > 0
            if success:
                logger.info(f"Updated language preferences for user_uuid={user_uuid}: app={app_language}, visit={visit_language}")
            else:
                logger.warning(f"User not found for language preferences update: {user_uuid}")

            return success

    except Exception as e:
        logger.error(f"Error updating language preferences for user_uuid={user_uuid}: {e}")
        raise