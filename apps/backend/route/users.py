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