"""
User management routes for authentication
"""
from fastapi import APIRouter, Body, Depends, Request

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.errors import ValidationError
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

router = APIRouter(prefix="/api/users", tags=["Users"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


@router.get("/profile")
async def get_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile"""
    external_auth_id = current_user.get("sub")
    user_data = await fetch_profile(external_auth_id)
    return UserResponse(**user_data)


@router.post("/")
def create_user_profile(request: CreateUserRequest):
    """Create user profile after signup - SUPABASE AUTH DECOMMISSIONED"""
    # SUPABASE AUTH DECOMMISSIONED: Block all new user creation via Supabase
    raise ValidationError(
        "Supabase authentication is no longer available for new users. Please use modern authentication methods.",
        status_code=410,
    )


@router.put("/{target_external_auth_id}/role")
async def update_user_role(
    target_external_auth_id: str,
    request: UpdateRoleRequest,
    current_user: dict = Depends(get_current_user),
):
    """Update user role - only allow users to update their own role"""
    current_external_auth_id = current_user.get("sub")
    user_data = await update_role(
        current_external_auth_id,
        target_external_auth_id,
        request.role,
    )
    return UserResponse(**user_data)


@router.post("/bootstrap")
async def bootstrap_user(
    request: BootstrapRequest | None = Body(default=None),
    current_user: dict = Depends(get_current_user)
):
    """Bootstrap user in Cloud SQL after authentication"""
    external_auth_id = current_user.get("sub")
    email = current_user.get("email")
    auth_display_name = current_user.get("name")
    request_full_name = request.full_name if request else None
    return await bootstrap(external_auth_id, email, request_full_name, auth_display_name)


@router.get("/me", response_model=UserMeResponse)
async def get_current_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile information"""
    external_auth_id = current_user.get("sub")
    user_data = await fetch_me(external_auth_id)
    return UserMeResponse(**user_data)


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
    external_auth_id = current_user.get("sub")
    preferences = await get_language_prefs(external_auth_id)
    return LanguagePreferencesResponse(**preferences)


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
    external_auth_id = current_user.get("sub")
    return await update_language_prefs(
        external_auth_id,
        request.app_language,
        request.visit_language,
    )


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
    external_auth_id = current_user.get("sub")
    result = await update_phone(external_auth_id, request.phone)
    return UpdatePhoneResponse(**result)