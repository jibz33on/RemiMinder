"""
User management routes for authentication
"""
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from services.auth_gateway import get_current_user_jwt as get_current_user
from services.supabase_client import supabase, check_table_exists

router = APIRouter(prefix="/api/users", tags=["Users"])

class UserResponse(BaseModel):
    id: str
    email: str
    full_name: Optional[str] = None
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

                # Convert row to dict matching the expected response format
                user_data = {
                    "id": str(row[0]),
                    "email": row[1],
                    "full_name": row[2],
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

        return UserResponse(**user_data.data)


@router.post("/")
def create_user_profile(request: CreateUserRequest):
    """Create user profile after signup"""
    try:
        print(f"Received user creation request: {request.dict()}")

        # Check if users table exists
        if not check_table_exists("users"):
            print("ERROR: Users table does not exist in Supabase!")
            raise HTTPException(
                500,
                "Database setup incomplete: Please create the 'users' table in Supabase. "
                "See documentation for required table schema."
            )

        # Check if user exists
        existing = supabase.table("users").select("id").eq("auth_uid", request.auth_uid).execute()
        if existing.data:
            print(f"User already exists: {request.auth_uid}")
            raise HTTPException(409, "User already exists")

        # Create user
        user_data = {
            "auth_uid": request.auth_uid,
            "email": request.email,
            "role": request.role,
            "full_name": request.full_name,
        }

        print(f"Creating user with data: {user_data}")
        result = supabase.table("users").insert(user_data).execute()

        if not result.data:
            print("Failed to create user in database")
            raise HTTPException(500, "Failed to create user")

        print(f"User created successfully: {result.data[0]}")
        return UserResponse(**result.data[0])

    except Exception as e:
        print(f"Error creating user: {str(e)}")
        raise HTTPException(500, f"Internal server error: {str(e)}")


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

        return UserResponse(**user_data.data)

    except Exception as e:
        print(f"Error updating user role: {str(e)}")
        raise HTTPException(500, f"Internal server error: {str(e)}")