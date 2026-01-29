from typing import Callable, Any

_provider: Callable[[], Any] | None = None


def set_db_engine_provider(provider: Callable[[], Any]) -> None:
    global _provider
    _provider = provider


def get_db_engine() -> Any:
    if _provider is None:
        raise RuntimeError("DB provider not configured")
    return _provider()
