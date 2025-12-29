import logging
import os
from typing import Optional

from supabase import create_client, Client

logger = logging.getLogger(__name__)

# Global variable to cache the client (lazy initialization)
_supabase_client: Optional[Client] = None

def get_supabase_client() -> Client:
    """Lazy initialization of Supabase client."""
    global _supabase_client
    if _supabase_client is not None:
        return _supabase_client

    # Read environment variables at runtime (not import time)
    supabase_url = os.getenv("SUPABASE_URL")
    supabase_key = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

    if not supabase_url or not supabase_key:
        raise RuntimeError(
            "Supabase client not initialized. Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables."
        )

    _supabase_client = create_client(supabase_url, supabase_key)
    return _supabase_client

# For backward compatibility, create a proxy object
class SupabaseProxy:
    """Proxy object that lazily initializes the Supabase client."""

    def __getattr__(self, name):
        return getattr(get_supabase_client(), name)


# Global proxy instance for backward compatibility
supabase = SupabaseProxy()

def check_table_exists(table_name: str) -> bool:
    """Check if a table exists in Supabase."""
    try:
        # Try to select from table with limit 1
        supabase.table(table_name).select("*").limit(1).execute()
        return True
    except RuntimeError as e:
        if "Supabase client not initialized" in str(e):
            logger.warning("Supabase client not initialized - skipping table check")
            return False
        raise e
    except Exception as e:
        error_str = str(e).lower()
        if "relation" in error_str and "does not exist" in error_str:
            return False
        # Re-raise other errors
        raise e
