from typing import Optional

from sqlalchemy import text

from domain.ports.db import get_db_engine
from domain.ports.logging import get_logger

logger = get_logger()


async def get_completed_summary_by_visit(visit_id: str) -> Optional[dict]:
    engine = get_db_engine()
    with engine.connect() as conn:
        row = conn.execute(
            text("""
                SELECT s.id,
                       s.summary_json,
                       s.completed_at,
                       v.user_id
                FROM stt2_structured_summaries s
                JOIN visits v ON v.id = s.visit_id
                WHERE s.visit_id = :visit_id
                  AND s.status = 'completed'
                LIMIT 1
            """),
            {"visit_id": visit_id},
        ).fetchone()
    if not row:
        return None
    return {
        "summary_id": str(row[0]),
        "summary_json": row[1],
        "completed_at": row[2],
        "user_id": row[3],
    }


async def has_tasks_for_visit(visit_id: str, summary_id: str) -> bool:
    engine = get_db_engine()
    with engine.connect() as conn:
        row = conn.execute(
            text("""
                SELECT 1
                FROM patient_tasks
                WHERE visit_id = :visit_id
                  AND source_type = 'stt2_summary'
                  AND source_id = :summary_id
                LIMIT 1
            """),
            {"visit_id": visit_id, "summary_id": summary_id},
        ).fetchone()
    return row is not None


async def has_reminders_for_visit(visit_id: str, actions: list[str]) -> bool:
    if not actions:
        return False
    engine = get_db_engine()
    with engine.connect() as conn:
        row = conn.execute(
            text("""
                SELECT 1
                FROM reminders
                WHERE visit_id = :visit_id
                  AND message = ANY(:messages)
                LIMIT 1
            """),
            {"visit_id": visit_id, "messages": actions},
        ).fetchone()
    return row is not None


async def insert_tasks_from_action_items(
    *,
    user_id: str,
    visit_id: str,
    summary_id: str,
    action_items: list[str],
) -> int:
    if not action_items:
        return 0
    engine = get_db_engine()
    insert_query = text("""
        INSERT INTO patient_tasks
        (user_id, visit_id, title, type, due_date, status, source_type, source_id)
        VALUES (:user_id, :visit_id, :title, :type, NULL, 'pending', 'stt2_summary', :source_id)
        ON CONFLICT (user_id, source_type, source_id, title, due_date) DO NOTHING
    """)
    created_count = 0
    with engine.begin() as conn:
        for title in action_items:
            result = conn.execute(
                insert_query,
                {
                    "user_id": user_id,
                    "visit_id": visit_id,
                    "title": title,
                    "type": "followup",
                    "source_id": summary_id,
                },
            )
            created_count += result.rowcount or 0
    return created_count


async def insert_reminders_from_actions(
    *,
    user_id: str,
    visit_id: str,
    actions: list[str],
    infer_schedule,
    is_medication_action,
) -> int:
    if not actions:
        return 0
    engine = get_db_engine()
    insert_query = text("""
        INSERT INTO reminders
        (user_id, visit_id, reminder_type, title, message, scheduled_time, timezone, recurrence, status)
        SELECT :user_id, :visit_id, :reminder_type, :title, :message, :scheduled_time, :timezone, :recurrence, :status
        WHERE NOT EXISTS (
            SELECT 1
            FROM reminders
            WHERE visit_id = :visit_id
              AND message = :message
        )
    """)
    created_count = 0
    with engine.begin() as conn:
        for action in actions:
            schedule = infer_schedule(action)
            if schedule is None:
                continue
            scheduled_time, recurrence = schedule
            reminder_type = "medication" if is_medication_action(action) else "task"
            title = action.strip()
            if len(title) > 60:
                title = f"{title[:57]}..."
            result = conn.execute(
                insert_query,
                {
                    "user_id": user_id,
                    "visit_id": visit_id,
                    "reminder_type": reminder_type,
                    "title": title,
                    "message": action,
                    "scheduled_time": scheduled_time,
                    "timezone": "UTC",
                    "recurrence": recurrence,
                    "status": "pending",
                },
            )
            created_count += result.rowcount or 0
    return created_count
