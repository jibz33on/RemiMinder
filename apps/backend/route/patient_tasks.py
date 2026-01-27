import logging

from fastapi import APIRouter, Depends
from sqlalchemy import text

from services.auth_gateway import get_current_user_jwt as get_current_user
from services.cloud_sql_engine import get_cloud_sql_engine

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api/patient/tasks", tags=["Patient Tasks"])


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract firebase_uid from authenticated user"""
    return current_user["sub"]


@router.get("")
async def get_patient_tasks(user_id: str = Depends(get_user_id)):
    engine = get_cloud_sql_engine()
    query = text("""
        SELECT *
        FROM patient_tasks
        WHERE user_id = :user_id
          AND status = 'pending'
        ORDER BY created_at DESC
    """)

    with engine.begin() as conn:
        result = conn.execute(query, {"user_id": user_id})
        rows = result.mappings().all()

    return rows


@router.post("/{task_id}/complete")
async def complete_task(task_id: str, user_id: str = Depends(get_user_id)):
    engine = get_cloud_sql_engine()
    query = text("""
        UPDATE patient_tasks
        SET status = 'completed',
            updated_at = now()
        WHERE id = :task_id
          AND user_id = :user_id
    """)

    with engine.begin() as conn:
        conn.execute(query, {"task_id": task_id, "user_id": user_id})

    return {"status": "ok"}


@router.post("/{task_id}/dismiss")
async def dismiss_task(task_id: str, user_id: str = Depends(get_user_id)):
    engine = get_cloud_sql_engine()
    query = text("""
        UPDATE patient_tasks
        SET status = 'dismissed',
            updated_at = now()
        WHERE id = :task_id
          AND user_id = :user_id
    """)

    with engine.begin() as conn:
        conn.execute(query, {"task_id": task_id, "user_id": user_id})

    return {"status": "ok"}
