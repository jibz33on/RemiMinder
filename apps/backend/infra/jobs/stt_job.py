import asyncio
from typing import Any, Dict


def run_stt_job(payload: Dict[str, Any]) -> None:
    """
    Execute the STT pipeline for a visit and save the transcript.
    """
    visit_id = payload["visit_id"]
    external_auth_id = payload.get("external_auth_id")
    if external_auth_id is None:
        raise KeyError("Missing external_auth_id in STT job payload")

    async def _run() -> None:
        from workflows.visit_processing import process_audio_visit

        await process_audio_visit(visit_id, external_auth_id)

    asyncio.run(_run())
