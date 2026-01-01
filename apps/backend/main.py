import logging
import os
import sys
from typing import Dict, Any

from dotenv import load_dotenv

logger = logging.getLogger(__name__)

# Explicitly load .env from backend directory
env_path = os.path.join(os.path.dirname(__file__), ".env")
try:
    load_dotenv(env_path)
except (FileNotFoundError, PermissionError):
    logger.warning(f"Could not load .env file from {env_path}. Make sure environment variables are set.")

# Verify critical environment variables are loaded
required_vars = ["SUPABASE_URL", "SUPABASE_SERVICE_ROLE_KEY", "GCS_BUCKET_NAME"]
for var in required_vars:
    if not os.getenv(var):
        raise RuntimeError(f"Critical environment variable {var} is not set. Check your .env file.")

# Check AI API keys (optional but logged)
openai_key = os.getenv("OPENAI_API_KEY")
gemini_key = os.getenv("GEMINI_API_KEY")

if openai_key:
    logger.info("OPENAI_API_KEY loaded")
else:
    logger.warning("OPENAI_API_KEY not set - will use mock transcription")

if gemini_key:
    logger.info("GEMINI_API_KEY loaded")
else:
    logger.warning("GEMINI_API_KEY not set - AI summaries will fail")

# Check Cloud SQL environment variables (optional for read-only testing)
cloud_sql_vars = ["DB_HOST", "DB_PORT", "DB_NAME", "DB_USER", "DB_PASSWORD"]
cloud_sql_configured = all(os.getenv(var) for var in cloud_sql_vars)

if cloud_sql_configured:
    logger.info("Cloud SQL PostgreSQL environment variables loaded (read-only connection available)")
else:
    logger.info("Cloud SQL PostgreSQL environment variables not set (optional for read-only testing)")

# Check database provider setting
db_provider = os.getenv("DB_PROVIDER", "supabase").lower()
if db_provider == "cloudsql":
    logger.info("Database provider set to: Cloud SQL")
elif db_provider == "supabase":
    logger.info("Database provider set to: Supabase (default)")
else:
    logger.warning(f"Unknown DB_PROVIDER '{db_provider}', will default to 'supabase'")

logger.info("Environment variables verified")

sys.path.append('..')

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from route import invitations, patient_register, caregiver_patient, caregivers, visit_summary, reminders, users

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:3000"],  # Frontend origin
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(invitations.router)        # Caregiver invitations
app.include_router(patient_register.router)   # Patient registration
app.include_router(caregivers.router)         # Caregiver registration
app.include_router(caregiver_patient.router)  # Caregiver-patient linking
app.include_router(visit_summary.router)      # Visit summaries
app.include_router(reminders.router)          # Reminders
app.include_router(users.router)              # User authentication

@app.get("/")
def root() -> Dict[str, str]:
    """Health check endpoint."""
    return {"message": "Backend running!"}


if __name__ == "__main__":
    import uvicorn
    # Run on all interfaces for development
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)