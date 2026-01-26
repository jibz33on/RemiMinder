from fastapi import HTTPException

from .db_service import get_care_team_membership
from services.cache_service import get, set


async def assert_patient_access(
    requester_user_id: str,
    patient_user_id: str,
    required_permission: str = "view",
) -> None:
    if requester_user_id == patient_user_id:
        return

    cache_key = f"care_team_member:{patient_user_id}:{requester_user_id}"
    membership = get(cache_key)
    if membership is None:
        membership = await get_care_team_membership(
            patient_id=patient_user_id,
            member_user_id=requester_user_id,
        )
        set(cache_key, membership, 60)

    if not membership:
        raise HTTPException(status_code=403, detail="No access to this patient's data")

    member_permission = membership.get("permission")
    if required_permission == "view":
        if member_permission in {"view", "full"}:
            return
        raise HTTPException(status_code=403, detail="Insufficient permission")

    if required_permission == "full":
        if member_permission == "full":
            return
        raise HTTPException(status_code=403, detail="Insufficient permission")

    raise HTTPException(status_code=403, detail="Insufficient permission")
