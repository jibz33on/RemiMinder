# server/main_backend/services/auth.py

from fastapi import Depends, HTTPException, status, Request
from supabase import create_client, Client
import os

# Initialize Supabase client (reuse your existing keys)
SUPABASE_URL = os.environ.get("SUPABASE_URL")
SUPABASE_ANON_KEY = os.environ.get("SUPABASE_ANON_KEY")  # use anon key for JWT verification
SUPABASE_SERVICE_KEY = os.environ.get("SUPABASE_SERVICE_ROLE_KEY")  # use service role for database operations

# Use anon key for auth operations (JWT verification)
supabase_auth: Client = create_client(SUPABASE_URL, SUPABASE_ANON_KEY)
# Use service key for database operations
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)

async def get_current_user(request: Request):
    """
    Extracts user info from Supabase JWT and returns internal user_id.
    """
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Missing or invalid token")

    token = auth_header.split(" ")[1]

    try:
        # Verify JWT with Supabase using anon key
        print(f"DEBUG: Verifying JWT token...")
        user_resp = supabase_auth.auth.get_user(token)
        print(f"DEBUG: JWT verification result: user={user_resp.user is not None}")

        if user_resp.user is None:
            print("DEBUG: JWT verification failed - user is None")
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid token")

        auth_id = user_resp.user.id
        print(f"DEBUG: Auth ID from JWT: {auth_id}")

        # Lookup internal user_id in users table using service key
        print(f"DEBUG: Looking up user in users table...")
        user_data = supabase.table("users").select("id,email,role").eq("auth_uid", auth_id).single().execute()
        print(f"DEBUG: User lookup result: data={user_data.data}")

        if not user_data.data:
            print("DEBUG: User not found in users table, creating user record...")
            # Create user record if it doesn't exist
            new_user = {
                "auth_uid": auth_id,
                "email": user_resp.user.email,
                "role": "user"  # Default role - matches database constraint
            }
            create_result = supabase.table("users").insert(new_user).execute()
            print(f"DEBUG: User creation result: {create_result.data}")

            if create_result.data:
                user_id = create_result.data[0]["id"]
                print(f"DEBUG: Created new user with id={user_id}")
                return user_id
            else:
                print("DEBUG: Failed to create user record")
                raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, detail="Failed to create user record")

        print(f"DEBUG: Authentication successful, user_id={user_data.data['id']}")
        return user_data.data["id"]

    except Exception as e:
        print(f"DEBUG: Auth error: {str(e)}")
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail=f"Auth error: {str(e)}")
