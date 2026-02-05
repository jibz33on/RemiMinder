import asyncio
from typing import Any, Dict

from domain.ports.logging import get_logger
from infra.db.cloud_sql_engine import get_cloud_sql_engine

logger = get_logger()


class STT2JobError(Exception):
    def __init__(self, stage: str, message: str) -> None:
        super().__init__(message)
        self.stage = stage


def run_stt2_job(payload: Dict[str, Any], job_id: str | None = None) -> None:
    """
    Execute the STT-2 placeholder extraction for a visit.
    """
    visit_id = payload.get("visit_id")
    if not visit_id:
        raise KeyError("Missing visit_id in STT-2 job payload")

    async def _run() -> None:
        from domain.stt2.service import run_stt2_extraction_job

        _update_job_heartbeat(job_id)
        logger.info("STT-2 extraction started visit_id=%s job_id=%s", visit_id, job_id)
        try:
            await run_stt2_extraction_job(visit_id, job_id=job_id)
        except ValueError as exc:
            stage = "parsing" if "valid JSON" in str(exc) else "validation"
            raise STT2JobError(stage, str(exc)) from exc
        except Exception as exc:
            raise STT2JobError("extraction", str(exc)) from exc
        finally:
            _update_job_heartbeat(job_id)
        logger.info("STT-2 extraction completed visit_id=%s job_id=%s", visit_id, job_id)

    asyncio.run(_run())
    logger.info("STT-2 summary persisted visit_id=%s job_id=%s", visit_id, job_id)


def _update_job_heartbeat(job_id: str | None) -> None:
    if not job_id:
        return
    try:
        engine = get_cloud_sql_engine()
        with engine.begin() as conn:
            conn.exec_driver_sql(
                """
                UPDATE jobs
                SET updated_at = now()
                WHERE id = :job_id
                """,
                {"job_id": job_id},
            )
    except Exception as exc:
        logger.warning("Failed to update STT-2 job heartbeat for job %s: %s", job_id, exc)