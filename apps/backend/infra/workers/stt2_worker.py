import os
import time
from datetime import datetime, timedelta, timezone

from infra.db.cloud_sql_engine import get_cloud_sql_engine
from infra.jobs.jobs_service import MAX_ATTEMPTS, claim_job, mark_done, mark_failed
from infra.jobs.stt2_job import STT2JobError, run_stt2_job
from infra.wiring import wire_infra_ports
from domain.ports.logging import get_logger
from sqlalchemy import text

JOB_TYPE = "stt2_extraction"
DEFAULT_TIMEOUT_SECONDS = 900

logger = get_logger()


def run_worker_loop() -> None:
    wire_infra_ports()
    while True:
        try:
            timeout_seconds = _get_timeout_seconds()
            _recover_stale_jobs(timeout_seconds)
            _recover_stale_summaries(timeout_seconds)

            job = claim_job(JOB_TYPE)
            if not job:
                time.sleep(2)
                continue

            job_id = job["id"]
            visit_id = None
            payload = job.get("payload") or {}
            if isinstance(payload, dict):
                visit_id = payload.get("visit_id")

            logger.info("STT-2 job started visit_id=%s job_id=%s", visit_id, job_id)
            _touch_job(job_id)
            try:
                run_stt2_job(payload, job_id=job_id)
                _touch_job(job_id)
                mark_done(job_id)
                logger.info("STT-2 job completed visit_id=%s job_id=%s", visit_id, job_id)
            except STT2JobError as exc:
                attempts = int(job.get("attempts", 0))
                logger.error(
                    "STT-2 job failed visit_id=%s job_id=%s stage=%s error=%s",
                    visit_id,
                    job_id,
                    exc.stage,
                    exc,
                )
                _handle_failed_job(job_id, attempts, str(exc))
            except Exception as exc:
                attempts = int(job.get("attempts", 0))
                logger.error(
                    "STT-2 job failed visit_id=%s job_id=%s stage=%s error=%s",
                    visit_id,
                    job_id,
                    "persistence",
                    exc,
                )
                _handle_failed_job(job_id, attempts, str(exc))
        except Exception as exc:
            logger.error("STT-2 worker loop error: %s", exc)
            time.sleep(2)


def _get_timeout_seconds() -> int:
    raw = os.getenv("STT2_JOB_TIMEOUT_SECONDS")
    if not raw:
        return DEFAULT_TIMEOUT_SECONDS
    try:
        return max(1, int(raw))
    except ValueError:
        return DEFAULT_TIMEOUT_SECONDS


def _recover_stale_jobs(timeout_seconds: int) -> None:
    cutoff = datetime.now(timezone.utc) - timedelta(seconds=timeout_seconds)
    engine = get_cloud_sql_engine()
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
                logger.error("STT-2 job exceeded max attempts; failing job_id=%s", job_id)
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
                logger.warning("Recovering stale STT-2 job %s", job_id)


def _recover_stale_summaries(timeout_seconds: int) -> None:
    cutoff = datetime.now(timezone.utc) - timedelta(seconds=timeout_seconds)
    engine = get_cloud_sql_engine()
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
            logger.warning("Recovered %s stale STT-2 summaries", result.rowcount)


def _touch_job(job_id: str) -> None:
    try:
        engine = get_cloud_sql_engine()
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
        logger.warning("Failed to update STT-2 job heartbeat for job %s: %s", job_id, exc)


def _handle_failed_job(job_id: str, attempts: int, error: str) -> None:
    if attempts >= MAX_ATTEMPTS:
        logger.error("STT-2 job reached max attempts; failing job_id=%s", job_id)
    mark_failed(job_id, error, attempts)


if __name__ == "__main__":
    run_worker_loop()
