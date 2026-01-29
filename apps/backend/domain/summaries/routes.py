import logging

from fastapi import APIRouter, Depends, HTTPException, Request

from domain.auth import get_current_user_jwt as get_current_user_port
from domain.errors import (
    ConflictError,
    DomainError,
    ForbiddenError,
    InternalError,
    NotFoundError,
    UnauthorizedError,
    ValidationError,
)
from domain.summaries.service import (
    get_structured_summary,
    get_summary,
    list_summaries,
    remove_summary,
)

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["Visit Summaries"])


def _raise_http_for_domain_error(error: DomainError) -> None:
    if isinstance(error, NotFoundError):
        raise HTTPException(status_code=404, detail=str(error))
    if isinstance(error, ForbiddenError):
        raise HTTPException(status_code=403, detail=str(error))
    if isinstance(error, ValidationError):
        raise HTTPException(status_code=400, detail=str(error))
    if isinstance(error, ConflictError):
        raise HTTPException(status_code=409, detail=str(error))
    if isinstance(error, UnauthorizedError):
        raise HTTPException(status_code=401, detail=str(error))
    if isinstance(error, InternalError):
        raise HTTPException(status_code=500, detail=str(error))
    raise HTTPException(status_code=500, detail=str(error))


def get_current_user(request: Request) -> dict:
    try:
        return get_current_user_port(request)
    except DomainError as error:
        _raise_http_for_domain_error(error)


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
    try:
        return await get_summary(user_id, visit_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get summary for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve summary: {str(e)}")


@router.get("/visits/{visit_id}/summary-structured")
async def get_visit_summary_structured(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get the latest AI-generated structured summary for a visit.
    Returns processing status if not ready, or structured JSON if available.
    """
    try:
        return await get_structured_summary(user_id, visit_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get structured summary for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve structured summary: {str(e)}")


@router.get("/summaries")
async def get_user_summaries_endpoint(
    user_id: str = Depends(get_user_id)
):
    """
    Get all summaries for the current user by joining summaries_log and visits tables.
    Returns list of summaries with visit metadata, ordered by newest first.
    """
    try:
        return await list_summaries(user_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to get summaries for user {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to retrieve summaries: {str(e)}")


@router.delete("/summaries/{summary_id}")
async def delete_user_summary_endpoint(
    summary_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Delete a summary by ID.
    Only allows deletion of summaries belonging to the current user.
    """
    try:
        return await remove_summary(user_id, summary_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Failed to delete summary {summary_id} for user {user_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Failed to delete summary: {str(e)}")
