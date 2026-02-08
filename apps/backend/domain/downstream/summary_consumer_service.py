from domain.ports.logging import get_logger
from domain.users.repo import get_user_uuid
from domain.users.service import assert_patient_access
from domain.downstream.repo import get_completed_summary_by_visit
from domain.downstream.reminder_generator import generate_reminders_for_summary
from domain.downstream.task_generator import generate_tasks_for_summary
from domain.downstream.visit_projection import build_summary_preview, normalize_summary_for_ui

logger = get_logger()


async def get_visit_detail_summary(external_auth_id: str, visit_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    summary = await get_completed_summary_by_visit(visit_id)
    if not summary:
        return {"status": "processing"}

    summary_json = normalize_summary_for_ui(summary.get("summary_json") or {})
    summary_preview = build_summary_preview(summary_json.get("summary") or "")
    return {
        "status": "completed",
        "summary": summary_json,
        "summary_preview": summary_preview,
        "completed_at": summary.get("completed_at"),
    }


async def get_patient_home_preview(external_auth_id: str, visit_id: str) -> dict:
    detail = await get_visit_detail_summary(external_auth_id, visit_id)
    if detail.get("status") != "completed":
        return {"status": "processing"}
    return {"status": "completed", "summary_preview": detail.get("summary_preview", "")}


async def process_downstream_for_visit(visit_id: str) -> None:
    summary = await get_completed_summary_by_visit(visit_id)
    if not summary:
        logger.info("STT-2 downstream skipped; summary not completed for visit %s", visit_id)
        return

    summary_json = summary.get("summary_json") or {}
    external_auth_id = summary.get("user_id")
    summary_id = summary.get("summary_id")
    if not external_auth_id or not summary_id:
        logger.warning("STT-2 downstream missing user_id or summary_id for visit %s", visit_id)
        return

    # Convert external_auth_id to UUID for database operations
    from domain.users.repo import get_user_uuid
    user_uuid = await get_user_uuid(external_auth_id)
    if not user_uuid:
        logger.warning("STT-2 downstream could not find UUID for external_auth_id %s", external_auth_id)
        return

    created_tasks = await generate_tasks_for_summary(
        user_id=user_uuid,
        visit_id=visit_id,
        summary_id=summary_id,
        action_items=summary_json.get("action_items"),
    )
    if created_tasks:
        logger.info("STT-2 downstream created %s tasks for visit %s", created_tasks, visit_id)

    created_reminders = await generate_reminders_for_summary(
        user_id=user_uuid,
        visit_id=visit_id,
        actions=summary_json.get("actions"),
    )
    if created_reminders:
        logger.info("STT-2 downstream created %s reminders for visit %s", created_reminders, visit_id)
