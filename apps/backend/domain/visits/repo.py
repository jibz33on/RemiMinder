import logging

from sqlalchemy import text

from domain.ports.db import get_db_engine

logger = logging.getLogger(__name__)


async def update_visit_with_structured_data(
    visit_id: str,
    doctor_name: str = None,
    specialty: str = None,
    title: str = None,
) -> None:
    """
    Update visit table with structured data extracted from AI summary.
    Only updates fields that are provided and not None.
    """
    try:
        engine = get_db_engine()
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

            logger.info(
                "Updating visit %s with fields: %s",
                visit_id,
                ", ".join(update_values.keys()),
            )
            conn.execute(update_query, update_values)
            logger.info(f"Updated visit {visit_id} with structured data: {list(update_values.keys())}")

    except Exception as e:
        logger.error(f"Error updating visit {visit_id} with structured data: {e}")
        raise


async def ensure_visit_exists(
    visit_id: str,
    user_id: str,
    title: str,
    status: str = "active",
) -> None:
    """
    Ensure a visit row exists for the provided ID.
    """
    try:
        engine = get_db_engine()
        with engine.begin() as conn:
            visit_query = text("""
                INSERT INTO visits (id, user_id, title, status)
                VALUES (:visit_id, :user_id, :title, :status)
                ON CONFLICT (id) DO NOTHING
            """)
            conn.execute(visit_query, {
                "visit_id": visit_id,
                "user_id": user_id,
                "title": title,
                "status": status,
            })
    except Exception as e:
        logger.error(f"Error ensuring visit row for visit {visit_id}: {e}")
        raise


async def get_visit_metadata(visit_id: str, user_id: str) -> dict:
    """
    Fetch visit metadata for a visit/user pair.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            row = conn.execute(
                text("""
                    SELECT id, doctor, specialty, title, created_at, status
                    FROM visits
                    WHERE id = :visit_id AND user_id = :user_id
                    LIMIT 1
                """),
                {"visit_id": visit_id, "user_id": user_id},
            ).fetchone()

        if not row:
            return None

        return {
            "id": str(row[0]),
            "doctor": row[1],
            "specialty": row[2],
            "title": row[3],
            "created_at": row[4].isoformat() if row[4] else None,
            "status": row[5],
        }
    except Exception as e:
        logger.error(f"Error fetching visit metadata for visit {visit_id}: {e}")
        raise


async def get_latest_processing_visit_id(external_auth_id: str) -> str | None:
    """
    Return the latest visit_id with a pending/running STT job for this user.
    """
    try:
        engine = get_db_engine()
        with engine.connect() as conn:
            row = conn.execute(
                text("""
                    SELECT payload->>'visit_id' AS visit_id
                    FROM jobs
                    WHERE job_type = 'STT_JOB'
                      AND status IN ('pending', 'running')
                      AND payload->>'external_auth_id' = :external_auth_id
                    ORDER BY created_at DESC
                    LIMIT 1
                """),
                {"external_auth_id": external_auth_id},
            ).fetchone()
        return row[0] if row else None
    except Exception as e:
        logger.error("Error fetching latest visit status for user %s: %s", external_auth_id, e)
        raise
