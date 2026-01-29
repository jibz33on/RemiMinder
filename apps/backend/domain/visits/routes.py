import logging
from fastapi import APIRouter, HTTPException, Depends, File, Request, UploadFile
# REMOVED: Legacy summary functions deleted during Supabase cleanup
# from services.db_service import (
#     fetch_visit_transcript,
#     fetch_visit_summary,
#     insert_visit_summary,
#     fetch_all_visit_summaries,
# )
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
from domain.visits.service import (
    get_latest_visit_status,
    get_visit_audio_url,
    get_visit_details,
    process_visit_ocr,
    queue_audio_processing,
    upload_visit_audio,
    upload_visit_image,
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
    # Auth provider user ID is the canonical user identity
    return current_user["sub"]

# DISABLED: Legacy summary generation route - functions removed during Supabase cleanup
# @router.post("/generate-summary/{visit_id}", response_model=VisitSummaryPayload)
# async def create_visit_summary(visit_id: str, user_id: str, transcript_id: str):
#     visit = await fetch_visit_transcript(visit_id, user_id, transcript_id)
#     if not visit or not visit.get("transcript_text"):
#         raise HTTPException(status_code=404, detail="Transcript not found")

#     ai_output = await generate_ai_summary({
#         "transcript": visit["transcript_text"],
#         "visit_id": visit_id,
#         "user_id": user_id,
#         "transcript_id": visit["transcript_id"]
#     })

#     await insert_visit_summary(visit_id, user_id, visit["transcript_id"], ai_output)

#     return {
#         "message": "Summary generated successfully",
#         "data": {
#             "visit_id": visit_id,
#             "user_id": user_id,
#             "transcript_id": transcript_id,
#             **ai_output,
#         }
#     }

# DISABLED: Legacy summary retrieval route - functions removed during Supabase cleanup
# @router.get("/visit-summaries/{visit_id}", response_model=VisitSummary)
# async def get_visit_summary(visit_id: int, user_id: int):
#     row = await fetch_visit_summary(visit_id, user_id)
#     if not row:
#         raise HTTPException(status_code=404, detail="Summary not found")
#     return row

# DISABLED: Legacy all summaries route - functions removed during Supabase cleanup
# @router.get("/visit-summaries")
# async def get_all_summaries(user_id: str = Depends(get_user_id)):
#     logger.info(f"Fetching visit summaries for user_id: {user_id}")
#     summaries = await fetch_all_visit_summaries(user_id)
#     logger.info(f"Found {len(summaries)} raw summaries from database")
#     formatted_summaries = []

#     for item in summaries:
#         visit_data = item.get('visits', {})
#         date_source = item.get('created_at')
#         visit_dt = datetime.now() if not date_source else datetime.fromisoformat(date_source.replace('Z', '+00:00'))

#         formatted_summaries.append({
#             "id": item.get('visit_id'),
#             "title": visit_data.get('title', 'Untitled Visit'),
#             "status": visit_data.get('status', 'Completed'),
#             "doctor": visit_data.get('doctor', 'N/A'),
#             "specialty": visit_data.get('specialty', 'General'),
#             "date": visit_dt.strftime("%b %d, %Y"),
#             "time": visit_dt.strftime("%I:%M %p"),
#             "duration": visit_data.get('duration', 'N/A'),
#             "summary": item.get('summary', 'No summary available.'),
#             "keyPoints": item.get('action_items', '').split(', ') if item.get('action_items') else [],
#         })

#     return formatted_summaries


@router.post("/visits/{visit_id}/audio/upload")
async def upload_audio_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    user_id: str = Depends(get_user_id)
):
    """
    Upload audio file with transactional database consistency.
    Creates visit and visit_transcripts rows if needed, then persists audio_url.
    """
    try:
        return await upload_visit_audio(user_id, visit_id, file)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Audio upload failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Audio upload failed: {str(e)}")


@router.post("/visits/{visit_id}/image/upload")
async def upload_image_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    user_id: str = Depends(get_user_id)
):
    """
    Upload image file with transactional database consistency.
    Creates visit and visit_transcripts rows if needed, then persists image_url and metadata.
    """
    try:
        return await upload_visit_image(user_id, visit_id, file)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Image upload failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Image upload failed: {str(e)}")


@router.post("/visits/{visit_id}/ocr")
async def process_visit_ocr(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Process uploaded image with OCR using Google Vision API.
    Thin route that delegates to image pipeline.
    """
    logger.info("OCR requested for visit_id=%s", visit_id)
    try:
        return await process_visit_ocr(user_id, visit_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except ValueError as e:
        # Pipeline validation errors
        if "not found" in str(e):
            raise HTTPException(status_code=404, detail=str(e))
        elif "already" in str(e):
            raise HTTPException(status_code=409, detail=str(e))
        else:
            raise HTTPException(status_code=400, detail=str(e))
    except DomainError as error:
        _raise_http_for_domain_error(error)
    except Exception as e:
        logger.exception(f"OCR route failed for visit {visit_id}")
        raise HTTPException(status_code=500, detail=f"OCR processing failed: {str(e)}")


@router.post("/visits/{visit_id}/process-audio")
async def process_visit_audio(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Process uploaded audio file with Speech-to-Text and save transcript.
    Background pipeline: GCS -> STT -> Cloud SQL.
    """
    return await queue_audio_processing(user_id, visit_id)


@router.get("/visits/latest/status")
async def get_latest_visit_status(user_id: str = Depends(get_user_id)):
    """
    Check whether the latest visit for this user is still processing.
    """
    try:
        from domain.ports.cache import get, set

        cache_key = f"visit_status:{user_id}"
        cached = get(cache_key)
        if cached is not None:
            return cached

        response = await get_latest_visit_status(user_id)
        set(cache_key, response, 5)
        return response

    except Exception as e:
        logger.error("Failed to fetch latest visit status for user %s: %s", user_id, e)
        raise HTTPException(status_code=500, detail="Failed to fetch latest visit status")


@router.get("/visits/{visit_id}/audio")
async def get_visit_audio_url_endpoint(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    try:
        return await get_visit_audio_url(user_id, visit_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve audio: {str(e)}")


@router.get("/visits/{visit_id}")
async def get_visit_metadata(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get visit metadata from visits table.
    """
    try:
        return await get_visit_details(user_id, visit_id)

    except DomainError as error:
        _raise_http_for_domain_error(error)
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve visit: {str(e)}")


