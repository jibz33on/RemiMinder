# Store your keys in .env file and load them using python-dotenv.
from supabase import create_client, Client
import os
from dotenv import load_dotenv

# Load environment variables from .env file in backend directory
# Temporarily disabled due to permission issues in development environment
# env_path = os.path.join(os.path.dirname(__file__), '..', '.env')
# if os.path.exists(env_path):
#     load_dotenv(env_path)

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

# In development, allow missing env vars (will be set via command line)
if not SUPABASE_URL or not SUPABASE_KEY:
    print("⚠️ SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY not found in .env")
    print("Set them via command line or environment variables")

    # Create a mock client that raises an error when used
    class MockSupabaseClient:
        def table(self, name):
            raise RuntimeError("Supabase client not initialized. Set SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables.")

    supabase = MockSupabaseClient()
else:
    supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_table_exists(table_name: str) -> bool:
    """Check if a table exists in Supabase"""
    try:
        # Try to select from table with limit 1
        supabase.table(table_name).select("*").limit(1).execute()
        return True
    except RuntimeError as e:
        if "Supabase client not initialized" in str(e):
            print("⚠️ Supabase client not initialized - skipping table check")
            return False
        raise e
    except Exception as e:
        error_str = str(e).lower()
        if "relation" in error_str and "does not exist" in error_str:
            return False
        # Re-raise other errors
        raise e
