import json
import logging
from typing import Optional

from sqlalchemy import text

from domain.ports.cache import invalidate
from domain.ports.db import get_db_engine

logger = logging.getLogger(__name__)


async def insert_ai_summary_log(
    transcript_id: str,
    visit_id: str,
    user_id: str,
    summary_text: str,
    structured_data: dict = None,
    model_name: str | None = None,
) -> str:
    """
    Insert AI-generated summary into summaries_log table with structured data.
    Used by AI pipeline to persist generated summaries.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            insert_query = text("""
                INSERT INTO summaries_log
                (transcript_id, visit_id, user_id, model_name, summary_text, structured_data_json, cost_usd)
                VALUES (:transcript_id, :visit_id, :user_id, :model, :summary, :structured_data, :cost)
                RETURNING id
            """)

            # Convert structured_data dict to JSON string if provided
            structured_data_json = None
            if structured_data is not None:
                structured_data_json = json.dumps(structured_data)

            result = conn.execute(insert_query, {
                "transcript_id": transcript_id,
                "visit_id": visit_id,
                "user_id": user_id,
                "model": model_name or "unknown",
                "summary": summary_text,
                "structured_data": structured_data_json,  # JSON string for JSONB column
                "cost": 0.001  # Placeholder cost, should be calculated properly
            })

            invalidate(f"summaries_list:{user_id}")
            row = result.fetchone()
            summary_id = str(row[0]) if row and row[0] else ""
            logger.info(f"Inserted AI summary with structured data for transcript {transcript_id}")
            return summary_id

    except Exception as e:
        logger.error(f"Error inserting AI summary for transcript {transcript_id}: {e}")
        raise


async def get_latest_ai_summary_for_visit(visit_id: str, user_id: str) -> Optional[str]:
    """
    Get the latest AI-generated summary for a visit from summaries_log table.
    Returns summary_text if exists, None if not found.
    Used by visit summary API to fetch processed summaries.
    """
    try:
        logger.info(f"Querying summaries_log for visit_id={visit_id}, user_id={user_id}")

        engine = get_db_engine()
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


async def get_latest_ai_structured_summary_for_visit(visit_id: str, user_id: str) -> Optional[dict]:
    """
    Get the latest structured AI summary for a visit from summaries_log table.
    Returns structured_data_json if exists, None if not found.
    Used by visit summary API to fetch structured summaries.
    """
    try:
        logger.info(f"Querying summaries_log structured data for visit_id={visit_id}, user_id={user_id}")

        engine = get_db_engine()
        with engine.connect() as conn:
            query = text("""
                SELECT structured_data_json, created_at FROM summaries_log
                WHERE visit_id = :visit_id AND user_id = :user_id
                ORDER BY created_at DESC
                LIMIT 1
            """)

            result = conn.execute(query, {"visit_id": visit_id, "user_id": user_id})
            row = result.fetchone()

            if row and row[0]:
                logger.info(
                    "Found structured summary for visit_id=%s, user_id=%s: created_at=%s",
                    visit_id,
                    user_id,
                    row[1],
                )
                structured_data = row[0]
                if isinstance(structured_data, str):
                    try:
                        structured_data = json.loads(structured_data)
                    except Exception:
                        pass
                return structured_data
            else:
                logger.info(f"No structured summary found for visit_id={visit_id}, user_id={user_id}")

            return None

    except Exception as e:
        logger.error(f"Error fetching structured AI summary for visit {visit_id}: {e}")
        raise


async def get_user_summaries(user_id: str) -> list[dict]:
    """
    Get all summaries for a user by joining summaries_log and visits tables.
    Returns list of summary objects with visit metadata, ordered by newest first.
    """
    try:
        logger.info(f"Fetching summaries for user_id={user_id}")

        engine = get_db_engine()
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
                    v.title AS title,
                    s.created_at AS visit_date
                FROM summaries_log s
                JOIN visits v ON v.id = s.visit_id
                WHERE s.user_id = :user_id
                ORDER BY s.created_at DESC;
            """)

            result = conn.execute(query, {"user_id": user_id})
            rows = result.fetchall()

            summaries = []
            for row in rows:
                summary_id, visit_id, summary_created_at, model_name, summary_text, doctor_name, specialty, title, visit_date = row

                # Truncate summary_text to ~160 characters for preview
                summary_preview = summary_text[:160] + "..." if len(summary_text) > 160 else summary_text

                summaries.append({
                    "summary_id": str(summary_id),
                    "visit_id": str(visit_id),
                    "doctor_name": doctor_name,
                    "specialty": specialty,
                    "title": title,
                    "visit_date": str(visit_date) if visit_date else None,
                    "summary_created_at": str(summary_created_at),
                    "summary_preview": summary_preview,
                    "model_name": model_name,
                })

            logger.info(f"Found {len(summaries)} summaries for user_id={user_id}")
            return summaries

    except Exception as e:
        logger.error(f"Error fetching user summaries for user_id={user_id}: {e}")
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
        engine = get_db_engine()
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
