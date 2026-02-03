from fastapi import APIRouter, Depends, Request
from domain.errors import PermissionDeniedError

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.patient_tasks.service import complete_task, dismiss_task, get_pending_tasks
from domain.users.service import assert_not_caregiver, assert_patient_access, assert_caregiver


router = APIRouter(prefix="/api/patient/tasks", tags=["Patient Tasks"])
caregiver_router = APIRouter(prefix="/api/patients", tags=["Caregiver Readonly"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract external_auth_id from authenticated user"""
    return current_user["sub"]


@router.get("")
async def get_patient_tasks(user_id: str = Depends(get_user_id)):
    return await get_pending_tasks(user_id)


@caregiver_router.get("/{patient_id}/tasks")
async def get_patient_tasks_for_caregiver(
    patient_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Read-only tasks for a caregiver-selected patient.
    """
    caregiver_id = current_user.get("sub")
    if not caregiver_id:
        raise PermissionDeniedError("Invalid token", status_code=401)
    await assert_caregiver(caregiver_id)
    await assert_patient_access(caregiver_id, patient_id, "view")
    return await get_pending_tasks(patient_id)


@router.post("/{task_id}/complete")
async def complete_task_endpoint(task_id: str, user_id: str = Depends(get_user_id)):
    await assert_not_caregiver(user_id)
    return await complete_task(task_id, user_id)


@router.post("/{task_id}/dismiss")
async def dismiss_task_endpoint(task_id: str, user_id: str = Depends(get_user_id)):
    await assert_not_caregiver(user_id)
    return await dismiss_task(task_id, user_id)
