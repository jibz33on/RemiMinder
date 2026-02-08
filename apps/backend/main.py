
"""
IMPORTANT:

This backend uses a background job worker for long-running tasks (STT + AI summary).

To fully run the system locally, you MUST run:

1) Backend API:
   uvicorn main:app --reload

2) Worker process (in separate terminal):
   python -m infra.workers.stt2_worker

If the worker is not running, audio uploads will succeed but summaries will NEVER be generated.
"""
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse

from domain.errors import (
    ConflictError,
    InternalError,
    NotFoundError,
    PermissionDeniedError,
    ValidationError,
)
from infra.env import load_env, validate_env
from infra.logging.config import configure_logging
from infra.wiring import configure_auth_overrides, wire_infra_ports


def create_app() -> FastAPI:
    load_env()
    validate_env()
    configure_logging()

    app = FastAPI()

    wire_infra_ports()
    configure_auth_overrides(app)
    from domain.ports.logging import get_logger
    logger = get_logger()

    # Import routes after wiring is complete to ensure logger is available
    from domain.care_team import routes as care_team_routes
    from domain.patient_tasks import routes as patient_tasks_routes
    from domain.reminders import routes as reminders_routes
    from domain.summaries import routes as summaries_routes
    from domain.users import routes as users_routes
    from domain.visits import routes as visits_routes
    logger = get_logger()

    @app.exception_handler(NotFoundError)
    async def handle_not_found(request: Request, exc: NotFoundError):
        logger.exception(
            "Domain error",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc)})

    @app.exception_handler(PermissionDeniedError)
    async def handle_permission_denied(request: Request, exc: PermissionDeniedError):
        logger.exception(
            "Domain error",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc)})

    @app.exception_handler(ValidationError)
    async def handle_validation_error(request: Request, exc: ValidationError):
        logger.exception(
            "Domain error",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc)})

    @app.exception_handler(ConflictError)
    async def handle_conflict(request: Request, exc: ConflictError):
        logger.exception(
            "Domain error",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc)})

    @app.exception_handler(InternalError)
    async def handle_internal_error(request: Request, exc: InternalError):
        logger.exception(
            "Domain error",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=exc.status_code, content={"error": str(exc)})

    @app.exception_handler(Exception)
    async def handle_unexpected_error(request: Request, exc: Exception):
        logger.exception(
            "Unhandled exception",
            error=str(exc),
            type=exc.__class__.__name__,
            path=str(request.url),
            method=request.method,
        )
        return JSONResponse(status_code=500, content={"error": str(exc)})

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
    app.include_router(summaries_routes.router)      # AI summaries
    app.include_router(users_routes.router)          # User authentication
    app.include_router(care_team_routes.router)      # Care team invitations
    app.include_router(patient_tasks_routes.router)  # Patient tasks
    app.include_router(patient_tasks_routes.caregiver_router)  # Caregiver read-only
    app.include_router(reminders_routes.router)      # Reminders
    return app


app = create_app()

@app.get("/")
def root() -> dict:
    """Health check endpoint."""
    return {"message": "Backend running!"}


@app.get("/health/db")
def db_health() -> dict:
    """Database health check endpoint."""
    from infra.db.cloud_sql_engine import get_database_health
    return get_database_health()


if __name__ == "__main__":
    import uvicorn
    # Run on all interfaces for development
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)