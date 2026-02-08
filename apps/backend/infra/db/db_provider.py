from .cloud_sql_engine import get_cloud_sql_engine as _get_cloud_sql_engine
from domain.ports.logging import get_logger

logger = get_logger()


def get_cloud_sql_engine():
    """
    Get database engine (Cloud SQL or local PostgreSQL).

    Returns:
        Engine: SQLAlchemy database engine
    """
    try:
        logger.info("Requesting database engine")
        engine = _get_cloud_sql_engine()
        logger.info("Database engine provided successfully")
        return engine
    except Exception as e:
        logger.error(f"Failed to get database engine: {e}")
        raise RuntimeError(f"Database engine retrieval failed: {e}")
