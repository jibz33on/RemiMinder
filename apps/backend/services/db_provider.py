import logging
import os
from typing import Optional

from sqlalchemy import Engine

from .cloud_sql_engine import get_cloud_sql_engine

logger = logging.getLogger(__name__)

# Global variable to cache the Cloud SQL engine (lazy initialization)
_cloud_sql_engine: Optional[Engine] = None

def get_active_provider() -> str:
    """
    Get the currently active database provider.

    Reads DB_PROVIDER environment variable:
    - "supabase" (default): Use existing Supabase client access
    - "cloudsql": Use Cloud SQL SQLAlchemy engine

    This is an asymmetrical design:
    - Supabase: Uses existing client/REST mechanisms (no SQLAlchemy)
    - Cloud SQL: Uses SQLAlchemy engine
    """
    provider = os.getenv("DB_PROVIDER", "supabase").lower()
    if provider not in ["supabase", "cloudsql"]:
        logger.warning(f"Unknown DB_PROVIDER '{provider}', defaulting to 'supabase'")
        return "supabase"
    return provider

def get_cloud_sql_engine_if_enabled() -> Optional[Engine]:
    """
    Get Cloud SQL SQLAlchemy engine only if Cloud SQL is enabled.

    Returns the Cloud SQL engine when DB_PROVIDER="cloudsql".
    Returns None otherwise (Supabase is active).

    This maintains the asymmetrical design where:
    - Supabase access continues using existing client patterns
    - Cloud SQL access uses SQLAlchemy when explicitly enabled
    """
    if get_active_provider() != "cloudsql":
        return None

    global _cloud_sql_engine
    if _cloud_sql_engine is not None:
        return _cloud_sql_engine

    try:
        logger.info("Initializing Cloud SQL database provider")
        _cloud_sql_engine = get_cloud_sql_engine()
        logger.info("Cloud SQL database provider initialized successfully")
        return _cloud_sql_engine
    except Exception as e:
        logger.error(f"Failed to initialize Cloud SQL provider: {e}")
        raise RuntimeError(f"Cloud SQL provider initialization failed: {e}")

def is_cloud_sql_enabled() -> bool:
    """Check if Cloud SQL is the active database provider."""
    return get_active_provider() == "cloudsql"

def is_supabase_enabled() -> bool:
    """Check if Supabase is the active database provider (default)."""
    return get_active_provider() == "supabase"
