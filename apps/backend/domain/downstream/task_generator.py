from domain.ports.logging import get_logger
from domain.downstream.repo import has_tasks_for_visit, insert_tasks_from_action_items

logger = get_logger()


def _normalize_items(items: object) -> list[str]:
    if not isinstance(items, list):
        return []
    return [str(item).strip() for item in items if str(item).strip()]


async def generate_tasks_for_summary(
    *,
    user_id: str,
    visit_id: str,
    summary_id: str,
    action_items: object,
) -> int:
    normalized = _normalize_items(action_items)
    if not normalized:
        return 0
    if await has_tasks_for_visit(visit_id, summary_id):
        logger.info("STT-2 tasks already generated for visit %s", visit_id)
        return 0
    created_count = await insert_tasks_from_action_items(
        user_id=user_id,
        visit_id=visit_id,
        summary_id=summary_id,
        action_items=normalized,
    )
    return created_count
