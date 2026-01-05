"""
Supabase client configuration for database operations.

This module provides the Supabase client for database operations.
Note: Supabase auth has been migrated to Firebase, but database operations
may still use Supabase for now.
"""
import os
import logging
from typing import Any, Dict, Optional

from supabase import create_client, Client

logger = logging.getLogger(__name__)

# Global Supabase client
_supabase_client: Optional[Client] = None

def get_supabase_client() -> Client:
    """
    Get or create Supabase client instance.

    Returns:
        Client: Supabase client instance
    """
    global _supabase_client
    if _supabase_client is not None:
        return _supabase_client

    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

    if not supabase_url or not supabase_key:
        raise RuntimeError(
            "Supabase environment variables not set. "
            "Please set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY in your .env file."
        )

    try:
        _supabase_client = create_client(supabase_url, supabase_key)
        logger.info("Supabase client initialized successfully")
        return _supabase_client
    except Exception as e:
        logger.error(f"Failed to initialize Supabase client: {e}")
        raise RuntimeError(f"Supabase client initialization failed: {e}")

# For backward compatibility - direct access to client
def _get_supabase():
    return get_supabase_client()

supabase = property(_get_supabase)

def check_table_exists(table_name: str) -> bool:
    """
    Check if a table exists in the database.

    Args:
        table_name: Name of the table to check

    Returns:
        bool: True if table exists, False otherwise
    """
    try:
        client = get_supabase_client()
        # Try to select from the table
        response = client.table(table_name).select("id").limit(1).execute()
        return True
    except Exception:
        return False


# services/supabase_client.py
def get_supabase_client():
    raise RuntimeError("Supabase is deprecated. Do not use in runtime paths.")
