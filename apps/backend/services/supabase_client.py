# Store your keys in .env file and load them using python-dotenv.
from supabase import create_client, Client
import os
from dotenv import load_dotenv

load_dotenv(dotenv_path='../.env')

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY")

assert SUPABASE_URL is not None, "SUPABASE_URL not set in .env"
assert SUPABASE_KEY is not None, "SUPABASE_SERVICE_ROLE_KEY not set in .env"

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def check_table_exists(table_name: str) -> bool:
    """Check if a table exists in Supabase"""
    try:
        # Try to select from table with limit 1
        supabase.table(table_name).select("*").limit(1).execute()
        return True
    except Exception as e:
        error_str = str(e).lower()
        if "relation" in error_str and "does not exist" in error_str:
            return False
        # Re-raise other errors
        raise e
