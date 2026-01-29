import logging

from domain.patient_tasks.repo import (
    _normalize_items,
    insert_reminders_from_actions,
    insert_tasks_from_actions,
    list_pending_tasks,
    update_task_status,
)

logger = logging.getLogger(__name__)


async def get_pending_tasks(user_id: str) -> list[dict]:
    return await list_pending_tasks(user_id)


async def complete_task(task_id: str, user_id: str) -> dict:
    await update_task_status(task_id, user_id, "completed")
    return {"status": "ok"}


async def dismiss_task(task_id: str, user_id: str) -> dict:
    await update_task_status(task_id, user_id, "dismissed")
    return {"status": "ok"}


async def generate_tasks_from_summary(
    *,
    user_id: str,
    visit_id: str,
    summary_id: str,
    structured_summary: dict,
) -> None:
    actions = _normalize_items(structured_summary.get("actions") if isinstance(structured_summary, dict) else None)
    created_count = await insert_tasks_from_actions(
        user_id=user_id,
        visit_id=visit_id,
        summary_id=summary_id,
        actions=actions,
    )
    if not created_count:
        logger.info("No tasks to insert for summary_id=%s", summary_id)
        return
    logger.info("Created %d tasks from AI actions for visit %s", created_count, visit_id)


async def generate_reminders_from_actions(
    *,
    user_id: str,
    visit_id: str,
    actions: list[str],
) -> None:
    created_count = await insert_reminders_from_actions(
        user_id=user_id,
        visit_id=visit_id,
        actions=actions,
    )
    if not created_count:
        logger.info("No reminders to create for visit %s", visit_id)
        return
    logger.info("Created %d reminders from AI actions for visit %s", created_count, visit_id)
