from typing import Any, Callable, Dict

_create_job: Callable[[str, Dict[str, Any]], str] | None = None


def set_job_creator(provider: Callable[[str, Dict[str, Any]], str]) -> None:
    global _create_job
    _create_job = provider


def create_job(job_type: str, payload: Dict[str, Any]) -> str:
    if _create_job is None:
        raise RuntimeError("Job provider not configured")
    return _create_job(job_type, payload)
