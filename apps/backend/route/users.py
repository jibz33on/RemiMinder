"""
User management routes for authentication
"""
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel
from typing import Optional
from services.auth import get_current_user
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
def get_user_profile(user_id: str = Depends(get_current_user)):
    """Get current user's profile"""
    # Check if users table exists
    if not check_table_exists("users"):
        raise HTTPException(
            500,
            "Database setup incomplete: Please create the 'users' table in Supabase."
        )

    user_data = supabase.table("users").select("id,email,full_name,role").eq("id", user_id).single().execute()

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


@router.put("/{user_id}/role")
def update_user_role(user_id: str, request: UpdateRoleRequest, current_user: str = Depends(get_current_user)):
    """Update user role - only allow users to update their own role"""
    print(f"BACKEND: Role update requested - user_id: {user_id}, current_user: {current_user}, new_role: {request.role}")

    # Check if users table exists
    if not check_table_exists("users"):
        print("BACKEND: Users table doesn't exist")
        raise HTTPException(
            500,
            "Database setup incomplete: Please create the 'users' table in Supabase."
        )

    # Only allow users to update their own role
    if current_user != user_id:
        print(f"BACKEND: Permission denied - current_user ({current_user}) != user_id ({user_id})")
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
        result = supabase.table("users").update({"role": db_role}).eq("id", user_id).execute()

        if not result.data:
            raise HTTPException(404, "User not found")

        # Return updated user data
        user_data = supabase.table("users").select("id,email,full_name,role").eq("id", user_id).single().execute()

        if not user_data.data:
            raise HTTPException(404, "User not found after update")

        return UserResponse(**user_data.data)

    except Exception as e:
        print(f"Error updating user role: {str(e)}")
        raise HTTPException(500, f"Internal server error: {str(e)}")