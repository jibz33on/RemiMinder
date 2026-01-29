from __future__ import annotations

from pathlib import Path

from infra.db.cloud_sql_engine import get_cloud_sql_engine
from domain.ports.logging import get_logger


MIGRATIONS_DIR = Path(__file__).resolve().parent / "migrations"
logger = get_logger()


def apply_migrations() -> None:
    migration_files = sorted(MIGRATIONS_DIR.glob("*.sql"))
    if not migration_files:
        raise RuntimeError(f"No migration files found in {MIGRATIONS_DIR}")

    engine = get_cloud_sql_engine()
    with engine.begin() as conn:
        applied_rows = conn.exec_driver_sql(
            "SELECT filename FROM schema_migrations;"
        ).fetchall()
        applied = {row[0] for row in applied_rows}

        for migration_file in migration_files:
            if migration_file.name in applied:
                continue
            sql = migration_file.read_text()
            if not sql.strip():
                continue
            conn.exec_driver_sql(sql)
            conn.exec_driver_sql(
                "INSERT INTO schema_migrations(filename) VALUES (%(filename)s)",
                {"filename": migration_file.name},
            )
            logger.info(f"Applied migration {migration_file.name}")


if __name__ == "__main__":
    apply_migrations()
