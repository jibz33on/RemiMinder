import asyncio
import logging
import secrets
from datetime import datetime, timezone

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, EmailStr

from services.auth_gateway import get_current_user_jwt as get_current_user
from services.db_service import (
    add_care_team_member,
    cancel_care_team_invitation,
    create_care_team_invitation,
    get_care_team_invitation_by_token,
    get_care_team_members,
    get_care_team_member_by_id,
    get_my_care_team_invitations,
    get_pending_care_team_invitations,
    get_user_email,
    get_user_uuid,
    mark_care_team_invitation_accepted,
    remove_care_team_member,
    resend_care_team_invitation,
    update_care_team_member_permission,
)
from services.invitation_email_service import send_invite_email

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/care-team", tags=["Care Team"])


class CareTeamInviteRequest(BaseModel):
    email: EmailStr
    role: str
    permission: str


class CareTeamAcceptRequest(BaseModel):
    token: str


class CareTeamPermissionUpdateRequest(BaseModel):
    permission: str


@router.get("", status_code=status.HTTP_200_OK)
async def list_care_team_members(
    current_user: dict = Depends(get_current_user),
):
    """
    List care team members for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        patient_id = await get_user_uuid(firebase_uid)
        members = await get_care_team_members(patient_id)
        return members

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to list care team members: {e}")
        raise HTTPException(status_code=500, detail="Failed to load care team")


@router.post("/invite", status_code=status.HTTP_201_CREATED)
async def invite_care_team_member(
    request: CareTeamInviteRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Create a care team invitation for a caregiver.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        if request.permission not in {"view", "full"}:
            raise HTTPException(status_code=400, detail="Invalid permission")

        if not request.role.strip():
            raise HTTPException(status_code=400, detail="Role is required")

        patient_id = await get_user_uuid(firebase_uid)
        token = secrets.token_urlsafe(32)

        await create_care_team_invitation(
            patient_id=patient_id,
            invitee_email=request.email,
            role=request.role.strip(),
            permission=request.permission,
            token=token,
            invited_by_user_id=patient_id,
        )

        patient_name = current_user.get("name") or "Your patient"
        try:
            await asyncio.to_thread(
                send_invite_email,
                to_email=request.email,
                invite_token=token,
                patient_name=patient_name,
            )
        except Exception as e:
            logger.warning(f"Failed to send care team invite email: {e}")

        return {"status": "sent"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to create care team invitation: {e}")
        raise HTTPException(status_code=500, detail="Failed to create invitation")


@router.post("/accept", status_code=status.HTTP_200_OK)
async def accept_care_team_invitation(
    request: CareTeamAcceptRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Accept a care team invitation by token.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        invitation = await get_care_team_invitation_by_token(request.token)
        if not invitation:
            raise HTTPException(status_code=404, detail="Invitation not found")

        if invitation["status"] != "pending":
            raise HTTPException(status_code=400, detail="Invitation is not pending")

        expires_at = invitation.get("expires_at")
        if expires_at:
            if isinstance(expires_at, str):
                expires_at = datetime.fromisoformat(expires_at)
            if expires_at < datetime.now(timezone.utc):
                raise HTTPException(status_code=400, detail="Invitation expired")

        member_user_id = await get_user_uuid(firebase_uid)

        await add_care_team_member(
            patient_id=str(invitation["patient_id"]),
            member_user_id=member_user_id,
            role=str(invitation["role"]),
            permission=str(invitation["permission"]),
            status="active",
            invited_by_user_id=invitation.get("invited_by_user_id"),
        )

        updated = await mark_care_team_invitation_accepted(
            invitation_id=str(invitation["id"]),
            accepted_by_user_id=member_user_id,
        )
        if not updated:
            raise HTTPException(status_code=404, detail="Invitation not found")

        return {"status": "accepted"}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to accept care team invitation: {e}")
        raise HTTPException(status_code=500, detail="Failed to accept invitation")


@router.get("/my-invitations", status_code=status.HTTP_200_OK)
async def list_my_care_team_invitations(
    current_user: dict = Depends(get_current_user),
):
    """
    List pending care team invitations for the current caregiver.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        user_id = await get_user_uuid(firebase_uid)
        user_email = await get_user_email(user_id)
        invitations = await get_my_care_team_invitations(user_email)
        return invitations

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to list care team invitations: {e}")
        raise HTTPException(status_code=500, detail="Failed to load invitations")


@router.get("/pending", status_code=status.HTTP_200_OK)
async def list_pending_care_team_invitations(
    current_user: dict = Depends(get_current_user),
):
    """
    List pending care team invitations for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        patient_id = await get_user_uuid(firebase_uid)
        invitations = await get_pending_care_team_invitations(patient_id)
        return invitations

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to list pending care team invitations: {e}")
        raise HTTPException(status_code=500, detail="Failed to load invitations")


@router.delete("/pending/{invitation_id}", status_code=status.HTTP_200_OK)
async def cancel_pending_care_team_invitation(
    invitation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Cancel a pending care team invitation for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        patient_id = await get_user_uuid(firebase_uid)
        updated = await cancel_care_team_invitation(
            patient_id=patient_id,
            invitation_id=invitation_id,
        )
        if not updated:
            raise HTTPException(status_code=404, detail="Invitation not found")

        return {"success": True}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to cancel care team invitation: {e}")
        raise HTTPException(status_code=500, detail="Failed to cancel invitation")


@router.post("/pending/{invitation_id}/resend", status_code=status.HTTP_200_OK)
async def resend_pending_care_team_invitation(
    invitation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Resend a pending care team invitation for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        patient_id = await get_user_uuid(firebase_uid)
        token = await resend_care_team_invitation(
            patient_id=patient_id,
            invitation_id=invitation_id,
        )
        if not token:
            raise HTTPException(status_code=404, detail="Invitation not found")

        invitation = await get_care_team_invitation_by_token(token)
        if not invitation:
            raise HTTPException(status_code=404, detail="Invitation not found")

        patient_name = current_user.get("name") or "Your patient"
        try:
            await asyncio.to_thread(
                send_invite_email,
                to_email=invitation["invitee_email"],
                invite_token=token,
                patient_name=patient_name,
            )
        except Exception as e:
            logger.warning(f"Failed to resend care team invite email: {e}")

        return {"success": True}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to resend care team invitation: {e}")
        raise HTTPException(status_code=500, detail="Failed to resend invitation")


@router.patch("/{member_id}", status_code=status.HTTP_200_OK)
async def update_care_team_permission(
    member_id: str,
    request: CareTeamPermissionUpdateRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Update a care team member's permission for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        if request.permission not in {"view", "full"}:
            raise HTTPException(status_code=400, detail="Invalid permission")

        patient_id = await get_user_uuid(firebase_uid)
        member = await get_care_team_member_by_id(member_id)
        if not member:
            raise HTTPException(status_code=404, detail="Care team member not found")
        if str(member["patient_id"]) != str(patient_id):
            raise HTTPException(status_code=403, detail="Not authorized")

        updated = await update_care_team_member_permission(
            member_id=member_id,
            permission=request.permission,
        )
        if not updated:
            raise HTTPException(status_code=404, detail="Care team member not found")

        return {"success": True}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to update care team permission: {e}")
        raise HTTPException(status_code=500, detail="Failed to update permission")


@router.delete("/{member_id}", status_code=status.HTTP_200_OK)
async def delete_care_team_member_endpoint(
    member_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Delete a care team member for the current patient.
    """
    try:
        firebase_uid = current_user.get("sub")
        if not firebase_uid:
            raise HTTPException(status_code=401, detail="Invalid token")

        patient_id = await get_user_uuid(firebase_uid)
        member = await get_care_team_member_by_id(member_id)
        if not member:
            raise HTTPException(status_code=404, detail="Care team member not found")
        if str(member["patient_id"]) != str(patient_id):
            raise HTTPException(status_code=403, detail="Not authorized")

        deleted = await remove_care_team_member(member_id=member_id)
        if not deleted:
            raise HTTPException(status_code=404, detail="Care team member not found")

        return {"success": True}

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete care team member: {e}")
        raise HTTPException(status_code=500, detail="Failed to delete member")
