#!/usr/bin/env python3
"""
Script to update existing user role from 'user' to 'patient'
"""
import sys
import os
sys.path.append('apps/backend')

# Load environment variables
from dotenv import load_dotenv
load_dotenv()

from apps.backend.services.supabase_client import supabase

def update_user_role():
    try:
        # Update the user with auth_uid bc1bd438-0f55-4513-a8a6-47d9b08f30c3
        result = supabase.table("users").update({"role": "patient"}).eq("auth_uid", "bc1bd438-0f55-4513-a8a6-47d9b08f30c3").execute()

        print(f"Update result: {result}")
        if result.data:
            print("✅ User role updated successfully!")
            print(f"Updated user: {result.data}")
        else:
            print("❌ No user found or update failed")

    except Exception as e:
        print(f"❌ Error updating user role: {e}")

if __name__ == "__main__":
    update_user_role()
