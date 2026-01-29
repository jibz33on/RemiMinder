"""
User management routes for authentication
"""
import logging

from fastapi import APIRouter, Body, Depends, HTTPException, Request

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
from domain.users.service import (
    bootstrap,
    fetch_me,
    fetch_profile,
    get_language_prefs,
    update_language_prefs,
    update_phone,
    update_role,
)
from domain.users.models import (
    BootstrapRequest,
    CreateUserRequest,
    LanguagePreferencesResponse,
    UpdateLanguagePreferencesRequest,
    UpdatePhoneRequest,
    UpdatePhoneResponse,
    UpdateRoleRequest,
    UserMeResponse,
    UserResponse,
)

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/users", tags=["Users"])


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


@router.get("/profile")
async def get_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile"""
    external_auth_id = current_user.get("sub")
    try:
        user_data = await fetch_profile(external_auth_id)
        return UserResponse(**user_data)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except Exception as e:
        raise HTTPException(500, f"Database error: {str(e)}")


@router.post("/")
def create_user_profile(request: CreateUserRequest):
    """Create user profile after signup - SUPABASE AUTH DECOMMISSIONED"""
    # SUPABASE AUTH DECOMMISSIONED: Block all new user creation via Supabase
    raise HTTPException(
        status_code=410,  # Gone
        detail="Supabase authentication is no longer available for new users. Please use modern authentication methods."
    )


@router.put("/{target_external_auth_id}/role")
def update_user_role(target_external_auth_id: str, request: UpdateRoleRequest, current_user: dict = Depends(get_current_user)):
    """Update user role - only allow users to update their own role"""
    current_external_auth_id = current_user.get("sub")
    try:
        user_data = await update_role(
            current_external_auth_id,
            target_external_auth_id,
            request.role,
        )
        return UserResponse(**user_data)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(500, f"Database error: {str(e)}")


@router.post("/bootstrap")
async def bootstrap_user(
    request: BootstrapRequest | None = Body(default=None),
    current_user: dict = Depends(get_current_user)
):
    """Bootstrap user in Cloud SQL after authentication"""
    try:
        external_auth_id = current_user.get("sub")
        email = current_user.get("email")
        auth_display_name = current_user.get("name")
        request_full_name = request.full_name if request else None
        return await bootstrap(external_auth_id, email, request_full_name, auth_display_name)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except Exception as e:
        raise HTTPException(500, f"Bootstrap failed: {str(e)}")


@router.get("/me", response_model=UserMeResponse)
async def get_current_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile information"""
    try:
        external_auth_id = current_user.get("sub")
        user_data = await fetch_me(external_auth_id)
        return UserMeResponse(**user_data)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(500, f"Failed to get user profile: {str(e)}")


# =========================================
# Language Preferences Models
# =========================================

# =========================================
# Language Preferences Endpoints
# =========================================

@router.get("/language-preferences", response_model=LanguagePreferencesResponse)
async def get_language_preferences(current_user: dict = Depends(get_current_user)):
    """
    Get user's language preferences.

    Returns:
    {
      "app_language": "en",
      "visit_language": "es"
    }

    curl -X GET "http://localhost:8000/api/users/language-preferences" \
         -H "Authorization: Bearer YOUR_JWT_TOKEN"
    """
    try:
        external_auth_id = current_user.get("sub")
        preferences = await get_language_prefs(external_auth_id)
        return LanguagePreferencesResponse(**preferences)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get language preferences: {str(e)}")
        raise HTTPException(500, f"Failed to get language preferences: {str(e)}")


@router.put("/language-preferences")
async def update_language_preferences(
    request: UpdateLanguagePreferencesRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    Update user's language preferences.

    Body:
    {
      "app_language": "es",
      "visit_language": "en"
    }

    curl -X PUT "http://localhost:8000/api/users/language-preferences" \
         -H "Authorization: Bearer YOUR_JWT_TOKEN" \
         -H "Content-Type: application/json" \
         -d '{"app_language": "es", "visit_language": "en"}'
    """
    try:
        external_auth_id = current_user.get("sub")
        return await update_language_prefs(
            external_auth_id,
            request.app_language,
            request.visit_language,
        )
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Failed to update language preferences: {str(e)}")
        raise HTTPException(500, f"Failed to update language preferences: {str(e)}")


@router.put("/me/phone", response_model=UpdatePhoneResponse)
async def update_user_phone(
    request: UpdatePhoneRequest,
    current_user: dict = Depends(get_current_user)
):
    """
    Update current user's phone number.

    Body:
    {
      "phone": "+919999999999"
    }

    Returns:
    {
      "phone": "+919999999999"
    }

    curl -X PUT "http://localhost:8000/api/users/me/phone" \
         -H "Authorization: Bearer YOUR_JWT_TOKEN" \
         -H "Content-Type: application/json" \
         -d '{"phone": "+919999999999"}'
    """
    try:
        external_auth_id = current_user.get("sub")
        result = await update_phone(external_auth_id, request.phone)
        return UpdatePhoneResponse(**result)
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to update user phone: {str(e)}")
        raise HTTPException(500, f"Failed to update phone: {str(e)}")