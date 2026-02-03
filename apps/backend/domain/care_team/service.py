import asyncio
from datetime import datetime, timezone

from domain.errors import NotFoundError, PermissionDeniedError, ValidationError
from domain.ports.logging import get_logger

from domain.ports.cache import get, set, invalidate
from domain.care_team.repo import (
    add_care_team_member,
    cancel_care_team_invitation,
    create_care_team_invitation,
    get_care_team_invitation_by_token,
    get_care_team_member_by_id,
    get_care_team_members,
    get_my_patients,
    get_my_care_team_invitations,
    get_pending_care_team_invitations,
    mark_care_team_invitation_accepted,
    remove_care_team_member,
    resend_care_team_invitation,
    update_care_team_member_permission,
)
from domain.users.repo import get_user_email, get_user_uuid
from domain.users.service import assert_caregiver, assert_patient_access

# NOTE:
# users.role = identity role (patient, caregiver, admin)
# care_team_members.role = relationship role within a care team

logger = get_logger()


def send_invite_email(to_email: str, invite_token: str, patient_name: str) -> bool:
    logger.info(
        "📧 Invite email stub (no-op). to=%s, token=%s, patient=%s",
        to_email,
        invite_token,
        patient_name,
    )
    return True


async def list_members(external_auth_id: str) -> list[dict]:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    cache_key = f"care_team_list:{patient_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    members = await get_care_team_members(patient_id)
    set(cache_key, members, 60)
    return members


async def invite_member(
    external_auth_id: str,
    email: str,
    role: str,
    permission: str,
    patient_name: str,
    token: str,
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    membership_role = role
    membership_permission = permission
    patient_id = await get_user_uuid(external_auth_id)
    await create_care_team_invitation(
        patient_id=patient_id,
        invitee_email=email,
        role=membership_role,
        permission=membership_permission,
        token=token,
        invited_by_user_id=patient_id,
    )

    try:
        await asyncio.to_thread(
            send_invite_email,
            to_email=email,
            invite_token=token,
            patient_name=patient_name,
        )
    except Exception as e:
        logger.warning(f"Failed to send care team invite email: {e}")

    invalidate(f"care_team_pending:{patient_id}")
    invalidate(f"care_team_list:{patient_id}")
    return {"status": "sent"}


async def accept_invitation(
    external_auth_id: str,
    token: str,
    invitee_email: str,
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    invitation = await get_care_team_invitation_by_token(token)
    if not invitation:
        raise NotFoundError("Invitation not found")

    if invitation["status"] != "pending":
        raise ValidationError("Invitation is not pending")

    if not invitee_email:
        raise PermissionDeniedError("Invalid token: missing email", status_code=401)
    if invitation.get("invitee_email", "").lower() != invitee_email.lower():
        raise PermissionDeniedError("You are not the intended invitee", status_code=403)

    expires_at = invitation.get("expires_at")
    if expires_at:
        if isinstance(expires_at, str):
            expires_at = datetime.fromisoformat(expires_at)
        if expires_at < datetime.now(timezone.utc):
            raise ValidationError("Invitation expired")

    member_user_id = await get_user_uuid(external_auth_id)
    membership_role = str(invitation["role"])
    membership_permission = str(invitation["permission"])

    await add_care_team_member(
        patient_id=str(invitation["patient_id"]),
        member_user_id=member_user_id,
        role=membership_role,
        permission=membership_permission,
        status="active",
        invited_by_user_id=invitation.get("invited_by_user_id"),
    )
    await assert_patient_access(member_user_id, str(invitation["patient_id"]), "view")

    updated = await mark_care_team_invitation_accepted(
        invitation_id=str(invitation["id"]),
        accepted_by_user_id=member_user_id,
    )
    if not updated:
        raise NotFoundError("Invitation not found")

    patient_id = str(invitation["patient_id"])
    invalidate(f"care_team_pending:{patient_id}")
    invalidate(f"care_team_list:{patient_id}")
    invalidate(f"care_team_my_invites:{member_user_id}")
    return {"status": "accepted"}


async def list_my_invitations(external_auth_id: str) -> list[dict]:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    user_id = await get_user_uuid(external_auth_id)
    cache_key = f"care_team_my_invites:{user_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    user_email = await get_user_email(user_id)
    invitations = await get_my_care_team_invitations(user_email)
    set(cache_key, invitations, 60)
    return invitations


async def list_pending_invitations(external_auth_id: str) -> list[dict]:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    cache_key = f"care_team_pending:{patient_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached
    invitations = await get_pending_care_team_invitations(patient_id)
    set(cache_key, invitations, 60)
    return invitations


async def list_my_patients(external_auth_id: str) -> list[dict]:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    await assert_caregiver(external_auth_id)
    member_user_id = await get_user_uuid(external_auth_id)
    return await get_my_patients(member_user_id)


async def cancel_pending_invitation(external_auth_id: str, invitation_id: str) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    updated = await cancel_care_team_invitation(
        patient_id=patient_id,
        invitation_id=invitation_id,
    )
    if not updated:
        raise NotFoundError("Invitation not found")

    invalidate(f"care_team_pending:{patient_id}")
    invalidate(f"care_team_list:{patient_id}")
    return {"success": True}


async def resend_pending_invitation(
    external_auth_id: str,
    invitation_id: str,
    patient_name: str,
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    token = await resend_care_team_invitation(
        patient_id=patient_id,
        invitation_id=invitation_id,
    )
    if not token:
        raise NotFoundError("Invitation not found")

    invitation = await get_care_team_invitation_by_token(token)
    if not invitation:
        raise NotFoundError("Invitation not found")

    try:
        await asyncio.to_thread(
            send_invite_email,
            to_email=invitation["invitee_email"],
            invite_token=token,
            patient_name=patient_name,
        )
    except Exception as e:
        logger.warning(f"Failed to resend care team invite email: {e}")

    invalidate(f"care_team_pending:{patient_id}")
    invalidate(f"care_team_list:{patient_id}")
    return {"success": True}


async def update_permission(
    external_auth_id: str,
    member_id: str,
    permission: str,
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    member = await get_care_team_member_by_id(member_id)
    if not member:
        raise NotFoundError("Care team member not found")
    if str(member["patient_id"]) != str(patient_id):
        raise PermissionDeniedError("Not authorized", status_code=403)

    updated = await update_care_team_member_permission(
        member_id=member_id,
        permission=permission,
    )
    if not updated:
        raise NotFoundError("Care team member not found")

    invalidate(f"care_team_list:{patient_id}")
    return {"success": True}


async def delete_member(external_auth_id: str, member_id: str) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    patient_id = await get_user_uuid(external_auth_id)
    member = await get_care_team_member_by_id(member_id)
    if not member:
        raise NotFoundError("Care team member not found")
    if str(member["patient_id"]) != str(patient_id):
        raise PermissionDeniedError("Not authorized", status_code=403)

    deleted = await remove_care_team_member(member_id=member_id)
    if not deleted:
        raise NotFoundError("Care team member not found")

    invalidate(f"care_team_list:{patient_id}")
    return {"success": True}
