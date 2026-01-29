from fastapi import APIRouter, Depends, Request

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.summaries.service import (
    get_structured_summary,
    get_summary,
    list_summaries,
    remove_summary,
)

router = APIRouter(prefix="/api", tags=["Visit Summaries"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract external_auth_id from authenticated user"""
    return current_user["sub"]


@router.get("/visits/{visit_id}/summary")
async def get_visit_summary(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get the latest AI-generated summary for a visit.
    Returns processing status if not ready, or summary text if available.
    """
    return await get_summary(user_id, visit_id)


@router.get("/visits/{visit_id}/summary-structured")
async def get_visit_summary_structured(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get the latest AI-generated structured summary for a visit.
    Returns processing status if not ready, or structured JSON if available.
    """
    return await get_structured_summary(user_id, visit_id)


@router.get("/summaries")
async def get_user_summaries_endpoint(
    user_id: str = Depends(get_user_id)
):
    """
    Get all summaries for the current user by joining summaries_log and visits tables.
    Returns list of summaries with visit metadata, ordered by newest first.
    """
    return await list_summaries(user_id)


@router.delete("/summaries/{summary_id}")
async def delete_user_summary_endpoint(
    summary_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Delete a summary by ID.
    Only allows deletion of summaries belonging to the current user.
    """
    return await remove_summary(user_id, summary_id)
