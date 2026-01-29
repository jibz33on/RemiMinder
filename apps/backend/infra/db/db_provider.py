from typing import Optional

from sqlalchemy import Engine


from .cloud_sql_engine import get_cloud_sql_engine as _create_cloud_sql_engine
from domain.ports.logging import get_logger

logger = get_logger()

# Global variable to cache the Cloud SQL engine (lazy initialization)
_cloud_sql_engine: Optional[Engine] = None


def get_cloud_sql_engine() -> Engine:
    """
    Get Cloud SQL SQLAlchemy engine (singleton, lazy initialized).

    Returns:
        Engine: Cloud SQL SQLAlchemy engine
    """
    global _cloud_sql_engine

    if _cloud_sql_engine is not None:
        return _cloud_sql_engine

    try:
        logger.info("Initializing Cloud SQL database provider")
        _cloud_sql_engine = _create_cloud_sql_engine()
        logger.info("Cloud SQL database provider initialized successfully")
        return _cloud_sql_engine
    except Exception as e:
        logger.error(f"Failed to initialize Cloud SQL provider: {e}")
        raise RuntimeError(f"Cloud SQL provider initialization failed: {e}")
