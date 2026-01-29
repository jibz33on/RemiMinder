from fastapi import APIRouter, Depends, Request

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.patient_tasks.service import complete_task, dismiss_task, get_pending_tasks


router = APIRouter(prefix="/api/patient/tasks", tags=["Patient Tasks"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract external_auth_id from authenticated user"""
    return current_user["sub"]


@router.get("")
async def get_patient_tasks(user_id: str = Depends(get_user_id)):
    return await get_pending_tasks(user_id)


@router.post("/{task_id}/complete")
async def complete_task_endpoint(task_id: str, user_id: str = Depends(get_user_id)):
    return await complete_task(task_id, user_id)


@router.post("/{task_id}/dismiss")
async def dismiss_task_endpoint(task_id: str, user_id: str = Depends(get_user_id)):
    return await dismiss_task(task_id, user_id)
