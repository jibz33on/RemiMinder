from fastapi import HTTPException

from .db_service import get_care_team_membership


async def assert_patient_access(
    requester_user_id: str,
    patient_user_id: str,
    required_permission: str = "view",
) -> None:
    if requester_user_id == patient_user_id:
        return

    membership = await get_care_team_membership(
        patient_id=patient_user_id,
        member_user_id=requester_user_id,
    )

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
