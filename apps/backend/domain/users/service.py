from typing import Optional

from domain.errors import NotFoundError, PermissionDeniedError, ValidationError
from domain.ports.logging import get_logger

from domain.users.repo import (
    ensure_user_exists,
    get_user_language_preferences,
    get_user_profile,
    update_user_language_preferences,
    update_user_phone,
    update_user_role,
)
from domain.ports.cache import get, invalidate, set
from domain.care_team.repo import get_care_team_membership

logger = get_logger()


def resolve_display_name(full_name: Optional[str]) -> str:
    """
    Centralized display name resolution logic.
    """
    if full_name and full_name.strip():
        return full_name.strip()
    return "User"


async def fetch_profile(external_auth_id: str) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token: missing user ID", status_code=401)

    cache_key = f"user_profile:{external_auth_id}"
    cached = get(cache_key)
    if cached is not None:
        display_name = resolve_display_name(cached.get("full_name"))
        return {
            "id": str(cached["id"]),
            "email": cached["email"],
            "full_name": cached.get("full_name"),
            "display_name": display_name,
            "role": cached.get("db_role"),
        }

    user_data = await get_user_profile(external_auth_id)
    if not user_data:
        raise NotFoundError("User not found")

    display_name = resolve_display_name(user_data.get("full_name"))
    set(cache_key, user_data, 600)
    return {
        "id": user_data["id"],
        "email": user_data["email"],
        "full_name": user_data.get("full_name"),
        "display_name": display_name,
        "role": user_data["db_role"],
    }


async def update_role(
    current_external_auth_id: str,
    target_external_auth_id: str,
    role: str,
) -> dict:
    if not current_external_auth_id:
        raise PermissionDeniedError("Invalid token: missing user ID", status_code=401)

    if current_external_auth_id != target_external_auth_id:
        raise PermissionDeniedError("You can only update your own role", status_code=403)

    if role not in ["patient", "caregiver"]:
        raise ValidationError("Invalid role. Must be 'patient' or 'caregiver'")

    # Persist explicit roles; role is stored as patient/caregiver.
    user_data = await update_user_role(target_external_auth_id, role)
    if not user_data:
        raise NotFoundError("User not found")

    display_name = resolve_display_name(user_data.get("full_name"))
    invalidate(f"user_profile:{target_external_auth_id}")
    return {
        "id": user_data["id"],
        "email": user_data["email"],
        "full_name": user_data.get("full_name"),
        "display_name": display_name,
        "role": role,
    }


async def bootstrap(
    external_auth_id: str,
    email: str,
    request_full_name: Optional[str],
    auth_display_name: Optional[str],
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token: missing user ID", status_code=401)
    if not email:
        raise ValidationError("Email missing from auth token")

    created = await ensure_user_exists(
        external_auth_id,
        email,
        request_full_name,
        auth_display_name,
    )
    return {"status": "created" if created else "exists"}


async def fetch_me(external_auth_id: str) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid token: missing user ID", status_code=401)

    cache_key = f"user_profile:{external_auth_id}"
    cached = get(cache_key)
    if cached is not None:
        db_role = cached.get("db_role")
        api_role = None if not db_role or db_role == "user" else db_role
        return {
            "full_name": cached.get("full_name"),
            "email": cached["email"],
            "phone": cached.get("phone"),
            "role": api_role,
        }

    user_data = await get_user_profile(external_auth_id)
    if not user_data:
        raise NotFoundError("User not found")

    db_role = user_data.get("db_role")
    api_role = None if not db_role or db_role == "user" else db_role
    set(cache_key, user_data, 600)
    return {
        "full_name": user_data.get("full_name"),
        "email": user_data["email"],
        "phone": user_data.get("phone"),
        "role": api_role,
    }


async def get_language_prefs(external_auth_id: str) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid user authentication", status_code=401)

    cache_key = f"language_prefs:{external_auth_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached

    preferences = await get_user_language_preferences(external_auth_id)
    if preferences is None:
        raise NotFoundError("User not found")

    set(cache_key, preferences, 1800)
    return preferences


async def update_language_prefs(
    external_auth_id: str,
    app_language: str,
    visit_language: str,
) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid user authentication", status_code=401)

    success = await update_user_language_preferences(
        external_auth_id=external_auth_id,
        app_language=app_language,
        visit_language=visit_language,
    )
    if not success:
        raise NotFoundError("User not found")

    invalidate(f"language_prefs:{external_auth_id}")
    return {"status": "updated"}


async def update_phone(external_auth_id: str, phone: Optional[str]) -> dict:
    if not external_auth_id:
        raise PermissionDeniedError("Invalid user authentication", status_code=401)

    phone_to_save = None
    if phone is not None:
        phone_str = phone.strip()
        if phone_str and len(phone_str) < 8:
            raise ValidationError("Phone number must be at least 8 characters long")
        phone_to_save = phone_str if phone_str else None

    updated = await update_user_phone(external_auth_id, phone_to_save)
    if not updated:
        raise NotFoundError("User not found")

    invalidate(f"user_profile:{external_auth_id}")
    return {"phone": phone_to_save}


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
        raise PermissionDeniedError("No access to this patient's data", status_code=403)

    member_permission = membership.get("permission")
    if required_permission == "view":
        if member_permission in {"view", "full"}:
            return
        raise PermissionDeniedError("Insufficient permission", status_code=403)

    if required_permission == "full":
        if member_permission == "full":
            return
        raise PermissionDeniedError("Insufficient permission", status_code=403)

    raise PermissionDeniedError("Insufficient permission", status_code=403)
