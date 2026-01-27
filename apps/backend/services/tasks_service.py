import logging
import re
from datetime import datetime, timedelta, timezone
from typing import List, Optional, Tuple

from sqlalchemy import text

from services.cloud_sql_engine import get_cloud_sql_engine

logger = logging.getLogger(__name__)


def _normalize_items(items: object) -> List[str]:
    if not isinstance(items, list):
        return []
    return [str(item).strip() for item in items if str(item).strip()]


def _infer_reminder_schedule(action: str) -> Optional[Tuple[datetime, str]]:
    lowered = action.lower()
    now = datetime.now(timezone.utc)

    if "daily" in lowered:
        return now + timedelta(days=1), "daily"
    if "tomorrow" in lowered:
        return now + timedelta(days=1), "once"

    in_match = re.search(r"in\s+(\d+)\s+(day|days|week|weeks)", lowered)
    if in_match:
        count = int(in_match.group(1))
        unit = in_match.group(2)
        days = count * 7 if "week" in unit else count
        return now + timedelta(days=days), "once"

    if "next week" in lowered:
        return now + timedelta(days=7), "once"
    if "next month" in lowered:
        return now + timedelta(days=30), "once"

    # Default to 1 hour from now so reminders always land in upcoming.
    return now + timedelta(hours=1), "once"


def _is_medication_action(action: str) -> bool:
    lowered = action.lower()
    return any(token in lowered for token in ("medication", "pill", "tablet", "capsule", "dose", "mg", "take"))


async def generate_tasks_from_summary(
    *,
    user_id: str,
    visit_id: str,
    summary_id: str,
    structured_summary: dict,
) -> None:
    actions = _normalize_items(structured_summary.get("actions"))

    if not actions:
        logger.info("No tasks to insert for summary_id=%s", summary_id)
        return

    engine = get_cloud_sql_engine()
    insert_query = text("""
        INSERT INTO patient_tasks
        (user_id, visit_id, title, type, due_date, status, source_type, source_id)
        SELECT :user_id, :visit_id, :title, :type, NULL, 'pending', 'ai_summary', :source_id
        WHERE NOT EXISTS (
            SELECT 1
            FROM patient_tasks
            WHERE visit_id = :visit_id
              AND title = :title
        )
    """)

    with engine.begin() as conn:
        created_count = 0
        for title in actions:
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

    logger.info(
        "Created %d tasks from AI actions for visit %s",
        created_count,
        visit_id,
    )


async def generate_reminders_from_actions(
    *,
    user_id: str,
    visit_id: str,
    actions: List[str],
) -> None:
    if not actions:
        logger.info("No reminders to create for visit %s", visit_id)
        return

    engine = get_cloud_sql_engine()
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
            schedule = _infer_reminder_schedule(action)
            if schedule is None:
                continue
            scheduled_time, recurrence = schedule
            reminder_type = "medication" if _is_medication_action(action) else "task"
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

    logger.info(
        "Created %d reminders from AI actions for visit %s",
        created_count,
        visit_id,
    )
