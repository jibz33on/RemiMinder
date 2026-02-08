import importlib
import os
from typing import Any, Dict


async def run_audio_stt_pipeline(visit_id: str, external_auth_id: str) -> Dict[str, Any]:
    """
    Dynamically resolve and run STT provider at runtime.
    This ensures STT_PROVIDER environment variable is read after .env loading.
    """
    provider_path = os.getenv("STT_PROVIDER")
    print(f"DEBUG STT_PROVIDER = {repr(provider_path)}")
    if not provider_path:
        raise RuntimeError("STT provider not configured")

    try:
        module_path, func_name = provider_path.rsplit(":", 1)
        module = importlib.import_module(module_path)
        provider_fn = getattr(module, func_name)
        return await provider_fn(visit_id, external_auth_id)
    except (ImportError, AttributeError) as e:
        raise RuntimeError(f"Failed to load STT provider '{provider_path}': {e}")


# Legacy functions for backward compatibility (deprecated)
_stt_provider = None

def set_stt_provider(provider):
    """Deprecated: STT provider is now resolved dynamically"""
    global _stt_provider
    _stt_provider = provider
