import json
from typing import Any, Dict, Optional

from sqlalchemy import text

from infra.db.cloud_sql_engine import get_cloud_sql_engine
from domain.ports.logging import get_logger

logger = get_logger()

MAX_ATTEMPTS = 3


def create_job(job_type: str, payload: Dict[str, Any]) -> str:
    """
    Insert a new job with status 'pending' and return its id.
    """
    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                INSERT INTO jobs (job_type, status, payload)
                VALUES (:job_type, 'pending', :payload)
                RETURNING id
            """),
            {"job_type": job_type, "payload": json.dumps(payload)},
        )
        row = result.fetchone()
        if not row:
            raise RuntimeError("Failed to create job")
        return str(row[0])


def claim_job(job_type: str) -> Optional[Dict[str, Any]]:
    """
    Atomically claim one pending job of the given type.
    Marks it as running and increments attempts.
    Returns job data or None if none available.
    """
    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        row = conn.execute(
            text("""
                SELECT id, payload, attempts
                FROM jobs
                WHERE status = 'pending'
                  AND job_type = :job_type
                ORDER BY created_at ASC
                FOR UPDATE SKIP LOCKED
                LIMIT 1
            """),
            {"job_type": job_type},
        ).fetchone()

        if not row:
            return None

        job_id, payload, attempts = row
        next_attempts = int(attempts or 0) + 1

        conn.execute(
            text("""
                UPDATE jobs
                SET status = 'running',
                    attempts = :attempts,
                    updated_at = now()
                WHERE id = :job_id
            """),
            {"attempts": next_attempts, "job_id": job_id},
        )

        if isinstance(payload, str):
            try:
                payload = json.loads(payload)
            except Exception:
                payload = {"_raw_payload": payload}

        return {
            "id": str(job_id),
            "payload": payload,
            "attempts": next_attempts,
        }


def mark_done(job_id: str) -> None:
    """
    Mark a job as completed.
    """
    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        conn.execute(
            text("""
                UPDATE jobs
                SET status = 'completed',
                    updated_at = now()
                WHERE id = :job_id
            """),
            {"job_id": job_id},
        )


def mark_failed(job_id: str, error: str, attempts: int) -> None:
    """
    Mark a job as failed or return it to pending based on attempts.
    """
    next_status = "failed" if attempts >= MAX_ATTEMPTS else "pending"
    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        conn.execute(
            text("""
                UPDATE jobs
                SET status = :status,
                    last_error = :error,
                    updated_at = now()
                WHERE id = :job_id
            """),
            {"status": next_status, "error": error, "job_id": job_id},
        )
