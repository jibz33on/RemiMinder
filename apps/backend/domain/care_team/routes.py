import secrets

from fastapi import APIRouter, Depends, Request, status

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.errors import PermissionDeniedError, ValidationError
from domain.care_team.service import (
    accept_invitation,
    cancel_pending_invitation,
    delete_member,
    invite_member,
    list_members,
    list_my_invitations,
    list_pending_invitations,
    resend_pending_invitation,
    update_permission,
)
from domain.care_team.models import (
    CareTeamAcceptRequest,
    CareTeamInviteRequest,
    CareTeamPermissionUpdateRequest,
)

router = APIRouter(prefix="/api/care-team", tags=["Care Team"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


@router.get("", status_code=status.HTTP_200_OK)
async def list_care_team_members(
    current_user: dict = Depends(get_current_user),
):
    """
    List care team members for the current patient.
    """
    external_auth_id = current_user.get("sub")
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    return await list_members(external_auth_id)


@router.post("/invite", status_code=status.HTTP_201_CREATED)
async def invite_care_team_member(
    request: CareTeamInviteRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Create a care team invitation for a caregiver.
    """
    external_auth_id = current_user.get("sub")
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token", status_code=401)

    if request.permission not in {"view", "full"}:
        raise ValidationError("Invalid permission", status_code=400)

    if not request.role.strip():
        raise ValidationError("Role is required", status_code=400)

    token = secrets.token_urlsafe(32)
    patient_name = current_user.get("name") or "Your patient"
    return await invite_member(
        external_auth_id=external_auth_id,
        email=request.email,
        role=request.role.strip(),
        permission=request.permission,
        patient_name=patient_name,
        token=token,
    )


@router.post("/accept", status_code=status.HTTP_200_OK)
async def accept_care_team_invitation(
    request: CareTeamAcceptRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Accept a care team invitation by token.
    """
    external_auth_id = current_user.get("sub")
    return await accept_invitation(external_auth_id, request.token)


@router.get("/my-invitations", status_code=status.HTTP_200_OK)
async def list_my_care_team_invitations(
    current_user: dict = Depends(get_current_user),
):
    """
    List pending care team invitations for the current caregiver.
    """
    external_auth_id = current_user.get("sub")
    return await list_my_invitations(external_auth_id)


@router.get("/pending", status_code=status.HTTP_200_OK)
async def list_pending_care_team_invitations(
    current_user: dict = Depends(get_current_user),
):
    """
    List pending care team invitations for the current patient.
    """
    external_auth_id = current_user.get("sub")
    return await list_pending_invitations(external_auth_id)


@router.delete("/pending/{invitation_id}", status_code=status.HTTP_200_OK)
async def cancel_pending_care_team_invitation(
    invitation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Cancel a pending care team invitation for the current patient.
    """
    external_auth_id = current_user.get("sub")
    return await cancel_pending_invitation(external_auth_id, invitation_id)


@router.post("/pending/{invitation_id}/resend", status_code=status.HTTP_200_OK)
async def resend_pending_care_team_invitation(
    invitation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Resend a pending care team invitation for the current patient.
    """
    external_auth_id = current_user.get("sub")
    patient_name = current_user.get("name") or "Your patient"
    return await resend_pending_invitation(external_auth_id, invitation_id, patient_name)


@router.patch("/{member_id}", status_code=status.HTTP_200_OK)
async def update_care_team_permission(
    member_id: str,
    request: CareTeamPermissionUpdateRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Update a care team member's permission for the current patient.
    """
    external_auth_id = current_user.get("sub")
    if request.permission not in {"view", "full"}:
        raise ValidationError("Invalid permission", status_code=400)
    return await update_permission(external_auth_id, member_id, request.permission)


@router.delete("/{member_id}", status_code=status.HTTP_200_OK)
async def delete_care_team_member_endpoint(
    member_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Delete a care team member for the current patient.
    """
    external_auth_id = current_user.get("sub")
    return await delete_member(external_auth_id, member_id)
