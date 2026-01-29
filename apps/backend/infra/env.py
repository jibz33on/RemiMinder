import logging
import os

from dotenv import load_dotenv

logger = logging.getLogger(__name__)


def load_env() -> None:
    env_path = os.path.join(os.path.dirname(__file__), "..", ".env")
    try:
        load_dotenv(env_path)
    except (FileNotFoundError, PermissionError):
        logger.warning(
            "Could not load .env file from %s. Make sure environment variables are set.",
            env_path,
        )


def validate_env() -> None:
    required_vars = ["GCS_BUCKET_NAME"]
    for var in required_vars:
        if not os.getenv(var):
            raise RuntimeError(
                f"Critical environment variable {var} is not set. Check your .env file."
            )

    cloud_sql_vars = ["DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD"]
    cloud_sql_configured = all(os.getenv(var) for var in cloud_sql_vars)

    if cloud_sql_configured:
        logger.info("Cloud SQL PostgreSQL environment variables loaded (read-only connection available)")
    else:
        logger.info("Cloud SQL PostgreSQL environment variables not set (optional for read-only testing)")
