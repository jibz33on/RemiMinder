import logging
import secrets

from fastapi import APIRouter, Depends, HTTPException, Request, status

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.errors import (
    ConflictError,
    DomainError,
    ForbiddenError,
    InternalError,
    NotFoundError,
    UnauthorizedError,
    ValidationError,
)
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

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/care-team", tags=["Care Team"])


def _raise_http_for_domain_error(error: DomainError) -> None:
    if isinstance(error, NotFoundError):
        raise HTTPException(status_code=404, detail=str(error))
    if isinstance(error, ForbiddenError):
        raise HTTPException(status_code=403, detail=str(error))
    if isinstance(error, ValidationError):
        raise HTTPException(status_code=400, detail=str(error))
    if isinstance(error, ConflictError):
        raise HTTPException(status_code=409, detail=str(error))
    if isinstance(error, UnauthorizedError):
        raise HTTPException(status_code=401, detail=str(error))
    if isinstance(error, InternalError):
        raise HTTPException(status_code=500, detail=str(error))
    raise HTTPException(status_code=500, detail=str(error))


def get_current_user(request: Request) -> dict:
    try:
        return get_current_user_port(request)
    except DomainError as error:
        _raise_http_for_domain_error(error)


@router.get("", status_code=status.HTTP_200_OK)
async def list_care_team_members(
    current_user: dict = Depends(get_current_user),
):
    """
    List care team members for the current patient.
    """
    try:
        external_auth_id = current_user.get("sub")
        if not external_auth_id:
            raise HTTPException(status_code=401, detail="Invalid token")

        return await list_members(external_auth_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        if not external_auth_id:
            raise HTTPException(status_code=401, detail="Invalid token")

        if request.permission not in {"view", "full"}:
            raise HTTPException(status_code=400, detail="Invalid permission")

        if not request.role.strip():
            raise HTTPException(status_code=400, detail="Role is required")

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

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        return await accept_invitation(external_auth_id, request.token)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        return await list_my_invitations(external_auth_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        return await list_pending_invitations(external_auth_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        return await cancel_pending_invitation(external_auth_id, invitation_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        patient_name = current_user.get("name") or "Your patient"
        return await resend_pending_invitation(external_auth_id, invitation_id, patient_name)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        if request.permission not in {"view", "full"}:
            raise HTTPException(status_code=400, detail="Invalid permission")
        return await update_permission(external_auth_id, member_id, request.permission)

    except DomainError as error:
        _raise_http_for_domain_error(error)
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
        external_auth_id = current_user.get("sub")
        return await delete_member(external_auth_id, member_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete care team member: {e}")
        raise HTTPException(status_code=500, detail="Failed to delete member")
