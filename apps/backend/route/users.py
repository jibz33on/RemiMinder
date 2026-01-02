"""
User management routes for authentication
"""
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from services.auth_gateway import get_current_user_jwt as get_current_user
from services.supabase_client import supabase, check_table_exists

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
    from services.db_provider import get_cloud_sql_engine_if_enabled
    from sqlalchemy import text

    # Extract auth_uid from JWT
    auth_uid = current_user.get("sub")
    if not auth_uid:
        raise HTTPException(401, "Invalid token: missing user ID")

    # Check if Cloud SQL is enabled
    engine = get_cloud_sql_engine_if_enabled()

    if engine:
        # Cloud SQL path - query by auth_uid
        try:
            with engine.connect() as conn:
                result = conn.execute(
                    text("SELECT id, email, full_name, role FROM users WHERE auth_uid = :auth_uid LIMIT 1"),
                    {"auth_uid": auth_uid}
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
            # Log error but don't expose internal details
            print(f"Cloud SQL query error: {e}")
            raise HTTPException(500, "Database error")

    else:
        # Default Supabase path - query by auth_uid
        # Check if users table exists
        if not check_table_exists("users"):
            raise HTTPException(
                500,
                "Database setup incomplete: Please create the 'users' table in Supabase."
            )

        user_data = supabase.table("users").select("id,email,full_name,role").eq("auth_uid", auth_uid).single().execute()

        if not user_data.data:
            raise HTTPException(404, "User not found")

        # Resolve display name
        display_name = resolve_display_name(user_data.data.get("full_name"))

        # Add display_name to response
        response_data = user_data.data.copy()
        response_data["display_name"] = display_name

        return UserResponse(**response_data)


@router.post("/")
def create_user_profile(request: CreateUserRequest):
    """Create user profile after signup - SUPABASE AUTH DECOMMISSIONED"""
    # SUPABASE AUTH DECOMMISSIONED: Block all new user creation via Supabase
    raise HTTPException(
        status_code=410,  # Gone
        detail="Supabase authentication is no longer available for new users. Please use modern authentication methods."
    )


@router.put("/{target_auth_uid}/role")
def update_user_role(target_auth_uid: str, request: UpdateRoleRequest, current_user: dict = Depends(get_current_user)):
    """Update user role - only allow users to update their own role"""
    current_auth_uid = current_user.get("sub")
    if not current_auth_uid:
        raise HTTPException(401, "Invalid token: missing user ID")

    print(f"BACKEND: Role update requested - target_auth_uid: {target_auth_uid}, current_auth_uid: {current_auth_uid}, new_role: {request.role}")

    # Check if users table exists
    if not check_table_exists("users"):
        print("BACKEND: Users table doesn't exist")
        raise HTTPException(
            500,
            "Database setup incomplete: Please create the 'users' table in Supabase."
        )

    # Only allow users to update their own role
    if current_auth_uid != target_auth_uid:
        print(f"BACKEND: Permission denied - current_auth_uid ({current_auth_uid}) != target_auth_uid ({target_auth_uid})")
        raise HTTPException(403, "You can only update your own role")

    print("BACKEND: Permission check passed, proceeding with role update")

    # Validate role and map 'patient' to 'user' for database compatibility
    if request.role not in ["patient", "caregiver"]:
        raise HTTPException(400, "Invalid role. Must be 'patient' or 'caregiver'")

    # Map patient to user for database storage (database constraint only allows 'user', 'caregiver')
    db_role = "user" if request.role == "patient" else request.role
    print(f"BACKEND: Mapping role '{request.role}' to database role '{db_role}'")

    try:
        # Update user role
        result = supabase.table("users").update({"role": db_role}).eq("auth_uid", target_auth_uid).execute()

        if not result.data:
            raise HTTPException(404, "User not found")

        # Return updated user data
        user_data = supabase.table("users").select("id,email,full_name,role").eq("auth_uid", target_auth_uid).single().execute()

        if not user_data.data:
            raise HTTPException(404, "User not found after update")

        # Resolve display name
        display_name = resolve_display_name(user_data.data.get("full_name"))

        # Add display_name to response
        response_data = user_data.data.copy()
        response_data["display_name"] = display_name

        return UserResponse(**response_data)

    except Exception as e:
        print(f"Error updating user role: {str(e)}")
        raise HTTPException(500, f"Internal server error: {str(e)}")