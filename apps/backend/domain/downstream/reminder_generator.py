from domain.patient_tasks.repo import _infer_reminder_schedule, _is_medication_action
from domain.ports.logging import get_logger
from domain.downstream.repo import has_reminders_for_visit, insert_reminders_from_actions

logger = get_logger()


def _normalize_items(items: object) -> list[str]:
    if not isinstance(items, list):
        return []
    return [str(item).strip() for item in items if str(item).strip()]


async def generate_reminders_for_summary(
    *,
    user_id: str,
    visit_id: str,
    actions: object,
) -> int:
    normalized = _normalize_items(actions)
    if not normalized:
        return 0
    if await has_reminders_for_visit(visit_id, normalized):
        logger.info("STT-2 reminders already exist for visit %s; inserting missing only", visit_id)
    created_count = await insert_reminders_from_actions(
        user_id=user_id,
        visit_id=visit_id,
        actions=normalized,
        infer_schedule=_infer_reminder_schedule,
        is_medication_action=_is_medication_action,
    )
    return created_count
