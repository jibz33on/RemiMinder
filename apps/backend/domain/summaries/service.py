from domain.errors import NotFoundError
from domain.ports.logging import get_logger

from domain.summaries.repo import (
    delete_user_summary,
    get_latest_ai_structured_summary_for_visit,
    get_latest_ai_summary_for_visit,
    get_user_summaries,
)
from domain.users.repo import get_user_uuid
from domain.users.service import assert_patient_access
from domain.ports.cache import get, invalidate, set

logger = get_logger()


async def get_summary(external_auth_id: str, visit_id: str) -> dict:
    logger.info(f"Getting summary for visit_id={visit_id}, external_auth_id={external_auth_id}")

    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    summary_text = await get_latest_ai_summary_for_visit(visit_id, user_uuid)
    if summary_text:
        return {"summary": summary_text}
    return {"status": "processing"}


async def get_structured_summary(external_auth_id: str, visit_id: str) -> dict:
    logger.info(f"Getting structured summary for visit_id={visit_id}, external_auth_id={external_auth_id}")

    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    structured_data = await get_latest_ai_structured_summary_for_visit(visit_id, user_uuid)
    if structured_data:
        return structured_data
    return {"status": "processing"}


async def list_summaries(external_auth_id: str) -> list[dict]:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "view")

    cache_key = f"summaries_list:{user_uuid}"
    cached = get(cache_key)
    if cached is not None:
        return cached

    summaries = await get_user_summaries(user_uuid)
    set(cache_key, summaries, 120)
    return summaries


async def remove_summary(external_auth_id: str, summary_id: str) -> dict:
    user_uuid = await get_user_uuid(external_auth_id)
    await assert_patient_access(user_uuid, user_uuid, "full")

    deleted = await delete_user_summary(summary_id, user_uuid)
    if not deleted:
        raise NotFoundError("Summary not found or access denied")

    invalidate(f"summaries_list:{user_uuid}")
    return {"status": "ok"}
