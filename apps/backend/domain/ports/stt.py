from typing import Any, Callable, Dict

_stt_provider: Callable[[str, str], Dict[str, Any]] | None = None


def set_stt_provider(provider: Callable[[str, str], Dict[str, Any]]) -> None:
    global _stt_provider
    _stt_provider = provider


async def run_audio_stt_pipeline(visit_id: str, external_auth_id: str) -> Dict[str, Any]:
    if _stt_provider is None:
        raise RuntimeError("STT provider not configured")
    return await _stt_provider(visit_id, external_auth_id)
