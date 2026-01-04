"""
User management routes for authentication
"""
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from services.auth_gateway import get_current_user_jwt as get_current_user
from services.db_provider import get_cloud_sql_engine
from services.db_service import ensure_user_exists
from sqlalchemy import text

router = APIRouter(prefix="/api/users", tags=["Users"])


def resolve_display_name(full_name: str | None) -> str:
    """
    Centralized display name resolution logic.

    Resolution order:
    1. users.full_name (if non-null and non-empty)
    2. "User" (final fallback)

    Args:
        full_name: The full_name field from database

    Returns:
        Resolved display name (never empty)
    """
    if full_name and full_name.strip():
        return full_name.strip()
    return "User"


class UserResponse(BaseModel):
    id: str
    email: str
    full_name: Optional[str] = None
    display_name: str
    role: str


class CreateUserRequest(BaseModel):
    auth_uid: str
    email: str
    role: str
    full_name: Optional[str] = None


class UpdateRoleRequest(BaseModel):
    role: str


@router.get("/profile")
def get_user_profile(current_user: dict = Depends(get_current_user)):
    """Get current user's profile"""
    # Extract firebase_uid from JWT (Firebase auth only)
    firebase_uid = current_user.get("sub")
    if not firebase_uid:
        raise HTTPException(401, "Invalid token: missing user ID")

    # Cloud SQL query by firebase_uid
    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            result = conn.execute(
                text("SELECT id, email, full_name, role FROM users WHERE firebase_uid = :firebase_uid LIMIT 1"),
                {"firebase_uid": firebase_uid}
            )
            row = result.fetchone()

            if not row:
                raise HTTPException(404, "User not found")

            # Resolve display name
            display_name = resolve_display_name(row[2])

            # Convert row to dict matching the expected response format
            user_data = {
                "id": str(row[0]),
                "email": row[1],
                "full_name": row[2],
                "display_name": display_name,
                "role": row[3]
            }

            return UserResponse(**user_data)

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


@router.put("/{target_firebase_uid}/role")
def update_user_role(target_firebase_uid: str, request: UpdateRoleRequest, current_user: dict = Depends(get_current_user)):
    """Update user role - only allow users to update their own role"""
    current_firebase_uid = current_user.get("sub")
    if not current_firebase_uid:
        raise HTTPException(401, "Invalid token: missing user ID")

    # Only allow users to update their own role
    if current_firebase_uid != target_firebase_uid:
        raise HTTPException(403, "You can only update your own role")

    # Validate role and map 'patient' to 'user' for database compatibility
    if request.role not in ["patient", "caregiver"]:
        raise HTTPException(400, "Invalid role. Must be 'patient' or 'caregiver'")

    # Map patient to user for database storage (database constraint only allows 'user', 'caregiver')
    db_role = "user" if request.role == "patient" else request.role

    try:
        engine = get_cloud_sql_engine()
        with engine.connect() as conn:
            # Update user role
            update_result = conn.execute(
                text("UPDATE users SET role = :role WHERE firebase_uid = :firebase_uid"),
                {"role": db_role, "firebase_uid": target_firebase_uid}
            )
            conn.commit()

            if update_result.rowcount == 0:
                raise HTTPException(404, "User not found")

            # Return updated user data
            result = conn.execute(
                text("SELECT id, email, full_name, role FROM users WHERE firebase_uid = :firebase_uid LIMIT 1"),
                {"firebase_uid": target_firebase_uid}
            )
            row = result.fetchone()

            if not row:
                raise HTTPException(404, "User not found after update")

            # Resolve display name
            display_name = resolve_display_name(row[2])

            # Convert to response format
            user_data = {
                "id": str(row[0]),
                "email": row[1],
                "full_name": row[2],
                "display_name": display_name,
                "role": row[3]
            }

            return UserResponse(**user_data)

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(500, f"Database error: {str(e)}")


@router.post("/bootstrap")
async def bootstrap_user(current_user: dict = Depends(get_current_user)):
    """Bootstrap user in Cloud SQL after Firebase authentication"""
    firebase_uid = current_user.get("sub")
    if not firebase_uid:
        raise HTTPException(401, "Invalid token: missing user ID")

    email = current_user.get("email")
    if not email:
        raise HTTPException(400, "Email missing from Firebase token")

    try:
        created = await ensure_user_exists(firebase_uid, email)

        if created:
            return {"status": "created"}

        return {"status": "exists"}

    except Exception as e:
        raise HTTPException(500, f"Bootstrap failed: {str(e)}")