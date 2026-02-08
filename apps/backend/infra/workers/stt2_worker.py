print(">>> [STT2] module import started", flush=True)

import logging
import os
import time
from datetime import datetime, timedelta, timezone

# Force-enable INFO logging for worker visibility
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)

from dotenv import load_dotenv
from infra.env import load_env, validate_env
from infra.jobs.jobs_service import MAX_ATTEMPTS, claim_job, mark_done, mark_failed
from infra.jobs.stt2_job import STT2JobError, run_stt2_job
from infra.wiring import wire_worker_ports
from domain.ports.logging import get_logger
from sqlalchemy import create_engine, text
from sqlalchemy.pool import QueuePool

print(">>> [STT2] imports completed", flush=True)

# Load environment variables for worker process
print(">>> [STT2] loading .env file", flush=True)
load_dotenv()
load_env()
validate_env()

# STT provider is now resolved dynamically at runtime

JOB_TYPE = "stt2_extraction"
DEFAULT_TIMEOUT_SECONDS = 900

logger = logging.getLogger(__name__)

# Global variable to cache the sync engine (lazy initialization)
_sync_engine = None


def get_sync_db_engine():
    """Create sync SQLAlchemy engine for workers using DATABASE_URL_SYNC."""
    global _sync_engine
    if _sync_engine is not None:
        return _sync_engine

    database_url_sync = os.getenv("DATABASE_URL_SYNC")
    if not database_url_sync:
        raise RuntimeError("DATABASE_URL_SYNC environment variable not set")

    _sync_engine = create_engine(
        database_url_sync,
        future=True,
        pool_pre_ping=True,
        connect_args={
            "connect_timeout": 5,
        },
    )

    # Test the connection
    with _sync_engine.connect() as conn:
        conn.execute(text("SELECT 1"))
        logger.info("STT-2 worker database connection established successfully")

    return _sync_engine


def _verify_database_connection() -> None:
    """Verify database connection before starting job processing."""
    try:
        engine = get_sync_db_engine()
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        logger.info("Database connection verified")
    except Exception as e:
        logger.error(f"Database connection failed: {e}")
        raise


def run_worker_loop() -> None:
    """Main worker loop for processing STT-2 jobs."""
    logger.info("Starting STT-2 worker")
    wire_worker_ports()

    # Recover any failed jobs from previous runs
    _recover_failed_jobs()

    # Verify database connectivity
    _verify_database_connection()

    logger.info(f"STT-2 worker ready, polling for {JOB_TYPE} jobs")
    while True:
        try:
            # Recover any stale jobs or summaries before polling
            timeout_seconds = _get_timeout_seconds()
            _recover_stale_jobs(timeout_seconds)
            _recover_stale_summaries(timeout_seconds)

            # Poll for and claim one pending job
            logger.info("[STT2] Polling for jobs...")
            job = claim_job(JOB_TYPE)

            if not job:
                # No jobs available, wait before next poll
                logger.info("[STT2] No pending jobs found")
                time.sleep(2)
                continue

            # Extract job details
            job_id = job["id"]
            payload = job.get("payload") or {}
            visit_id = payload.get("visit_id") if isinstance(payload, dict) else None

            logger.info(f"[STT2] Claimed job {job_id} for visit {visit_id}")
            _update_job_heartbeat(job_id)
            try:
                logger.info(f"[STT2] Running STT for visit {visit_id}")
                run_stt2_job(payload, job_id=job_id)
                _update_job_heartbeat(job_id)
                mark_done(job_id)
                logger.info(f"[STT2] Job {job_id} completed successfully")
            except STT2JobError as exc:
                attempts = job.get("attempts", 0)
                logger.exception(f"[STT2] Job {job_id} failed")
                _handle_failed_job(job_id, attempts, str(exc))
            except Exception as exc:
                attempts = job.get("attempts", 0)
                logger.exception(f"[STT2] Job {job_id} failed")
                _handle_failed_job(job_id, attempts, str(exc))
        except Exception as exc:
            logger.exception("[STT2] Worker loop error")
            time.sleep(2)  # Brief pause before retry


def _get_timeout_seconds() -> int:
    raw = os.getenv("STT2_JOB_TIMEOUT_SECONDS")
    if not raw:
        return DEFAULT_TIMEOUT_SECONDS
    try:
        return max(1, int(raw))
    except ValueError:
        return DEFAULT_TIMEOUT_SECONDS


def _recover_stale_jobs(timeout_seconds: int) -> None:
    """Recover jobs that have been running too long (stale jobs)."""
    cutoff = datetime.now(timezone.utc) - timedelta(seconds=timeout_seconds)
    engine = get_sync_db_engine()
    with engine.begin() as conn:
        rows = conn.execute(
            text("""
                SELECT id, attempts
                FROM jobs
                WHERE job_type = :job_type
                  AND status = 'running'
                  AND updated_at < :cutoff
            """),
            {"job_type": JOB_TYPE, "cutoff": cutoff},
        ).fetchall()

        for row in rows:
            job_id, attempts = row
            next_attempts = int(attempts or 0) + 1
            if next_attempts >= MAX_ATTEMPTS:
                conn.execute(
                    text("""
                        UPDATE jobs
                        SET status = 'failed',
                            attempts = :attempts,
                            last_error = :error,
                            updated_at = now()
                        WHERE id = :job_id
                    """),
                    {
                        "job_id": job_id,
                        "attempts": next_attempts,
                        "error": "stale job timeout",
                    },
                )
                logger.error(f"STT-2 job exceeded max attempts; failing job_id={job_id}")
            else:
                conn.execute(
                    text("""
                        UPDATE jobs
                        SET status = 'pending',
                            attempts = :attempts,
                            updated_at = now()
                        WHERE id = :job_id
                    """),
                    {"job_id": job_id, "attempts": next_attempts},
                )
                logger.warning(f"Recovering stale STT-2 job {job_id}")


def _recover_stale_summaries(timeout_seconds: int) -> None:
    """Mark stale summary processing as failed."""
    cutoff = datetime.now(timezone.utc) - timedelta(seconds=timeout_seconds)
    engine = get_sync_db_engine()
    with engine.begin() as conn:
        result = conn.execute(
            text("""
                UPDATE stt2_structured_summaries s
                SET status = 'failed',
                    last_error = 'stale processing state',
                    updated_at = now()
                WHERE s.status = 'processing'
                  AND s.updated_at < :cutoff
                  AND NOT EXISTS (
                    SELECT 1
                    FROM jobs j
                    WHERE j.job_type = :job_type
                      AND j.status = 'running'
                      AND (j.payload ->> 'visit_id') = s.visit_id::text
                  )
            """),
            {"cutoff": cutoff, "job_type": JOB_TYPE},
        )
        if result.rowcount:
            logger.warning(f"Recovered {result.rowcount} stale STT-2 summaries")


def _recover_failed_jobs() -> None:
    """Recover failed STT jobs for retry if they haven't exceeded max attempts."""
    engine = get_sync_db_engine()
    with engine.begin() as conn:
        # First, find failed jobs that can be retried
        retryable_rows = conn.execute(
            text("""
                SELECT id, attempts
                FROM jobs
                WHERE job_type = :job_type
                  AND status = 'failed'
                  AND (attempts IS NULL OR attempts < :max_attempts)
            """),
            {"job_type": JOB_TYPE, "max_attempts": MAX_ATTEMPTS},
        ).fetchall()

        recovered_count = 0
        skipped_count = 0

        for row in retryable_rows:
            job_id, attempts = row
            next_attempts = int(attempts or 0) + 1

            # Reset job to pending state for retry
            conn.execute(
                text("""
                    UPDATE jobs
                    SET status = 'pending',
                        attempts = :attempts,
                        started_at = NULL,
                        locked_at = NULL,
                        worker_id = NULL,
                        updated_at = now()
                    WHERE id = :job_id
                """),
                {"job_id": job_id, "attempts": next_attempts},
            )
            recovered_count += 1

        # Count jobs that exceeded retry limit
        exceeded_rows = conn.execute(
            text("""
                SELECT COUNT(*)
                FROM jobs
                WHERE job_type = :job_type
                  AND status = 'failed'
                  AND attempts >= :max_attempts
            """),
            {"job_type": JOB_TYPE, "max_attempts": MAX_ATTEMPTS},
        ).fetchone()
        skipped_count = exceeded_rows[0] if exceeded_rows else 0

        if recovered_count > 0:
            logger.info(f"Recovered {recovered_count} failed STT jobs for retry")
        if skipped_count > 0:
            logger.warning(f"Skipped {skipped_count} STT jobs due to retry limit ({MAX_ATTEMPTS})")


def _update_job_heartbeat(job_id: str) -> None:
    """Update job heartbeat to prevent stale job recovery."""
    try:
        engine = get_sync_db_engine()
        with engine.begin() as conn:
            conn.execute(
                text("""
                    UPDATE jobs
                    SET updated_at = now()
                    WHERE id = :job_id
                """),
                {"job_id": job_id},
            )
    except Exception as exc:
        logger.warning(f"Failed to update job heartbeat for job {job_id}: {exc}")


def _handle_failed_job(job_id: str, attempts: int, error: str) -> None:
    if attempts >= MAX_ATTEMPTS:
        logger.error(f"STT-2 job reached max attempts; failing job_id={job_id}")
    mark_failed(job_id, error, attempts)


if __name__ == "__main__":
    print(">>> [STT2] __main__ reached", flush=True)
    run_worker_loop()
