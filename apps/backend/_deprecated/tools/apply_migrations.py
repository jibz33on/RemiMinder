from __future__ import annotations

import logging
from pathlib import Path

from services.cloud_sql_engine import get_cloud_sql_engine


MIGRATIONS_DIR = Path(__file__).resolve().parents[1] / "schemas" / "migrations"
logger = logging.getLogger(__name__)


def _split_sql(sql: str) -> list[str]:
    statements: list[str] = []
    buffer: list[str] = []
    for line in sql.splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith("--"):
            continue
        buffer.append(line)
        if stripped.endswith(";"):
            statements.append("\n".join(buffer))
            buffer = []
    if buffer:
        statements.append("\n".join(buffer))
    return statements


def apply_migrations() -> None:
    migration_files = sorted(MIGRATIONS_DIR.glob("*.sql"))
    if not migration_files:
        raise RuntimeError(f"No migration files found in {MIGRATIONS_DIR}")

    engine = get_cloud_sql_engine()
    for migration_file in migration_files:
        sql = migration_file.read_text()
        statements = _split_sql(sql)
        if not statements:
            continue
        with engine.begin() as conn:
            for statement in statements:
                conn.exec_driver_sql(statement)
        logger.info("Applied migration %s", migration_file.name)


if __name__ == "__main__":
    apply_migrations()
