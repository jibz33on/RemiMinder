"""
Simple in-process TTL cache for performance optimizations.

This cache is best-effort only:
- Per-process and in-memory (no shared state between workers)
- Entries expire based on wall-clock time
- Not suitable for correctness-critical or long-lived data

Use for short-lived derived data (lists, status checks, permissions, etc.)
where stale reads are acceptable and the source of truth remains the database.
"""

from __future__ import annotations

from typing import Any, Callable, Optional
import threading
import time

_cache: dict[str, tuple[float, Any]] = {}
_lock = threading.Lock()


def get(key: str) -> Optional[Any]:
    """
    Best-effort cache lookup.

    Returns None if the key is missing or expired. This cache is per-process
    and should not be used for correctness-critical data.
    """
    now = time.time()
    with _lock:
        entry = _cache.get(key)
        if not entry:
            return None
        expires_at, value = entry
        if expires_at <= now:
            _cache.pop(key, None)
            return None
        return value


def set(key: str, value: Any, ttl_seconds: int) -> None:
    """
    Store a value with a TTL in seconds.

    This is per-process, best-effort caching only. Values are not persisted.
    """
    expires_at = time.time() + max(0, int(ttl_seconds))
    with _lock:
        _cache[key] = (expires_at, value)


def get_or_set(key: str, ttl_seconds: int, loader: Callable[[], Any]) -> Any:
    """
    Get a cached value or compute and store it if missing or expired.

    The loader is invoked without holding the lock to avoid blocking other
    cache operations. This is best-effort and may compute the value more
    than once under concurrent access.
    """
    cached = get(key)
    if cached is not None:
        return cached

    value = loader()
    set(key, value, ttl_seconds)
    return value


def invalidate(key: str) -> None:
    """
    Remove a single cache entry if present.
    """
    with _lock:
        _cache.pop(key, None)


def invalidate_prefix(prefix: str) -> None:
    """
    Remove all cache entries whose keys start with the provided prefix.
    """
    with _lock:
        keys_to_delete = [k for k in _cache.keys() if k.startswith(prefix)]
        for key in keys_to_delete:
            _cache.pop(key, None)
