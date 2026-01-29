import time

from infra.jobs.stt_job import run_stt_job
from infra.jobs.jobs_service import claim_job, mark_done, mark_failed
from infra.wiring import wire_infra_ports

JOB_TYPE = "STT_JOB"


def run_worker_loop() -> None:
    wire_infra_ports()
    while True:
        job = claim_job(JOB_TYPE)
        if not job:
            time.sleep(2)
            continue

        try:
            run_stt_job(job["payload"])
            mark_done(job["id"])
        except Exception as exc:
            attempts = int(job.get("attempts", 0))
            mark_failed(job["id"], str(exc), attempts)


if __name__ == "__main__":
    run_worker_loop()
