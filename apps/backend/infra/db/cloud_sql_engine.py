import os
from typing import Optional

from sqlalchemy import create_engine, Engine, text
from sqlalchemy.engine import URL
from sqlalchemy.pool import QueuePool
from domain.ports.logging import get_logger

logger = get_logger()

# Use process-specific global to avoid uvicorn --reload issues
# Key is process ID to ensure per-process engines
_cloud_sql_engines: dict[int, Engine] = {}

def get_cloud_sql_engine() -> Engine:
    """Lazy initialization of Cloud SQL PostgreSQL engine with per-process caching."""
    import os
    process_id = os.getpid()

    # Check if we already have an engine for this process
    if process_id in _cloud_sql_engines:
        return _cloud_sql_engines[process_id]

    # Check for local development override first
    local_db_url = os.getenv("LOCAL_DB_URL")
    if local_db_url:
        logger.info("Using LOCAL_DB_URL override for local development")
        logger.info(f"Local database URL configured (no secrets shown)")

        try:
            engine = create_engine(
                local_db_url,
                poolclass=QueuePool,
                pool_size=5,
                max_overflow=10,
                pool_timeout=30,
                pool_recycle=3600,
                echo=False,
                connect_args={
                    "connect_timeout": 10,
                    "application_name": "MediMinder-Backend-Local",
                }
            )

            # Test the connection
            with engine.connect() as conn:
                conn.execute(text("SELECT 1"))
                logger.info("Local PostgreSQL connection established successfully")

            _cloud_sql_engines[process_id] = engine
            return engine

        except Exception as e:
            logger.error(f"Failed to initialize local database engine: {e}")
            raise RuntimeError(f"Local database engine initialization failed: {e}")

    # Cloud SQL path
    logger.info("Initializing Cloud SQL database provider")

    # Read environment variables at runtime (not import time)
    db_host = os.getenv("DB_HOST")
    db_port = os.getenv("DB_PORT")
    db_name = os.getenv("DB_NAME")
    db_user = os.getenv("DB_USER")
    db_password = os.getenv("DB_PASSWORD")

    # Log configuration (without secrets)
    logger.info(f"Cloud SQL configuration: host={db_host}, port={db_port}, database={db_name}, user={db_user}")

    # Check if all required environment variables are set
    missing_vars = []
    if not db_host:
        missing_vars.append("DB_HOST")
    if not db_port:
        missing_vars.append("DB_PORT")
    if not db_name:
        missing_vars.append("DB_NAME")
    if not db_user:
        missing_vars.append("DB_USER")
    if not db_password:
        missing_vars.append("DB_PASSWORD")

    if missing_vars:
        error_msg = (
            f"Cloud SQL engine not initialized. Missing environment variables: {', '.join(missing_vars)}. "
            "Set DB_HOST, DB_PORT, DB_NAME, DB_USER, and DB_PASSWORD for Cloud SQL connection. "
            "For local development, set LOCAL_DB_URL instead."
        )
        logger.error(error_msg)
        raise RuntimeError(error_msg)

    try:
        # Create database URL using SQLAlchemy URL.create() to safely handle special characters
        database_url = URL.create(
            drivername="postgresql",
            username=db_user,
            password=db_password,
            host=db_host,
            port=db_port,
            database=db_name
        )

        logger.info("Creating Cloud SQL engine with connection pooling")

        # Create engine with connection pooling
        engine = create_engine(
            database_url,
            poolclass=QueuePool,
            pool_size=5,
            max_overflow=10,
            pool_timeout=30,
            pool_recycle=3600,  # Recycle connections every hour
            echo=False,  # Set to True for SQL debugging
            connect_args={
                "connect_timeout": 10,
                "application_name": "MediMinder-Backend-Cloud",
                "sslmode": "require"
            }
        )

        # Test the connection
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
            logger.info("Cloud SQL PostgreSQL connection established successfully")

        # Cache the engine for this process
        _cloud_sql_engines[process_id] = engine
        return engine

    except Exception as e:
        logger.error(f"Failed to initialize Cloud SQL engine: {e}")
        raise RuntimeError(f"Cloud SQL engine initialization failed: {e}")

def is_cloud_sql_available() -> bool:
    """Check if database connection is available and configured."""
    try:
        get_cloud_sql_engine()
        return True
    except (RuntimeError, Exception):
        return False

def get_database_health() -> dict:
    """Health check for database connectivity."""
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            result = conn.execute(text("SELECT version()"))
            version = result.scalar()
            return {
                "status": "healthy",
                "engine_type": "cloud_sql" if os.getenv("LOCAL_DB_URL") is None else "local",
                "version": version[:50] + "..." if version and len(version) > 50 else version
            }
    except Exception as e:
        return {
            "status": "unhealthy",
            "error": str(e),
            "engine_type": "unknown"
        }
