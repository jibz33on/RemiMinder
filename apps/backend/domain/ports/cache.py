from typing import Any, Callable


class CacheProvider:
    def get(self, key: str) -> Any:
        raise NotImplementedError

    def set(self, key: str, value: Any, ttl_seconds: int) -> None:
        raise NotImplementedError

    def invalidate(self, key: str) -> None:
        raise NotImplementedError

    def invalidate_prefix(self, prefix: str) -> None:
        raise NotImplementedError

    def get_or_set(self, key: str, ttl_seconds: int, loader: Callable[[], Any]) -> Any:
        raise NotImplementedError


_provider: CacheProvider | None = None


def set_cache_provider(provider: CacheProvider) -> None:
    global _provider
    _provider = provider


def _require_provider() -> CacheProvider:
    if _provider is None:
        raise RuntimeError("Cache provider not configured")
    return _provider


def get(key: str) -> Any:
    return _require_provider().get(key)


def set(key: str, value: Any, ttl_seconds: int) -> None:
    _require_provider().set(key, value, ttl_seconds)


def invalidate(key: str) -> None:
    _require_provider().invalidate(key)


def invalidate_prefix(prefix: str) -> None:
    _require_provider().invalidate_prefix(prefix)


def get_or_set(key: str, ttl_seconds: int, loader: Callable[[], Any]) -> Any:
    return _require_provider().get_or_set(key, ttl_seconds, loader)
