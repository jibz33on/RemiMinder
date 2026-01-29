
"""
IMPORTANT:

This backend uses a background job worker for long-running tasks (STT + AI summary).

To fully run the system locally, you MUST run:

1) Backend API:
   uvicorn main:app --reload

2) Worker process (in a separate terminal):
   python -m infra.workers.stt_worker

If the worker is not running, audio uploads will succeed but summaries will NEVER be generated.
"""
import logging

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from domain.care_team import routes as care_team_routes
from domain.patient_tasks import routes as patient_tasks_routes
from domain.reminders import routes as reminders_routes
from domain.users import routes as users_routes
from domain.visits import routes as visits_routes
from infra.env import load_env, validate_env
from infra.wiring import configure_auth_overrides, wire_infra_ports

logger = logging.getLogger(__name__)


def create_app() -> FastAPI:
    load_env()
    validate_env()

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
# DISABLED: Other routes temporarily disabled to focus on audio + STT features
# app.include_router(invitations.router)        # Caregiver invitations
# app.include_router(patient_register.router)   # Patient registration
# app.include_router(caregivers.router)         # Caregiver registration
# app.include_router(caregiver_patient.router)  # Caregiver-patient linking
    app.include_router(visits_routes.router)         # Visit summaries (audio + STT only)
    app.include_router(users_routes.router)          # User authentication
    app.include_router(care_team_routes.router)      # Care team invitations
    app.include_router(patient_tasks_routes.router)  # Patient tasks
    app.include_router(reminders_routes.router)      # Reminders
    logger.info("Reminders routes registered")

    wire_infra_ports()
    configure_auth_overrides(app)

    return app


app = create_app()

@app.get("/")
def root() -> dict:
    """Health check endpoint."""
    return {"message": "Backend running!"}


if __name__ == "__main__":
    import uvicorn
    # Run on all interfaces for development
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)