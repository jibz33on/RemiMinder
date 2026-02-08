from fastapi import APIRouter, Depends, File, Request, UploadFile
# REMOVED: Legacy summary functions deleted during Supabase cleanup
# from services.db_service import (
#     fetch_visit_transcript,
#     fetch_visit_summary,
#     insert_visit_summary,
#     fetch_all_visit_summaries,
# )
from domain.auth import get_current_user_jwt as get_current_user_port
from domain.visits.service import (
    get_latest_visit_status,
    get_visit_audio_url,
    get_visit_details,
    process_visit_ocr,
    process_audio_with_stt_and_create_job,
    generate_visit_summary,
    upload_visit_audio,
    upload_visit_image,
)

router = APIRouter(prefix="/api", tags=["Visit Summaries"])


def get_current_user(request: Request) -> dict:
    return get_current_user_port(request)


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
    return await upload_visit_audio(user_id, visit_id, file)


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
    return await upload_visit_image(user_id, visit_id, file)


@router.post("/visits/{visit_id}/ocr")
async def process_visit_ocr(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Process uploaded image with OCR using Google Vision API.
    Thin route that delegates to image pipeline.
    """
    return await process_visit_ocr(user_id, visit_id)


@router.post("/visits/{visit_id}/process-audio")
async def process_visit_audio(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    LEGACY: Full pipeline processing with STT + job creation.
    Use /generate-summary for Stage 2 job creation only.
    """
    return await process_audio_with_stt_and_create_job(user_id, visit_id)


@router.post("/visits/{visit_id}/generate-summary")
async def generate_visit_summary_endpoint(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Stage 2: Create processing job for visit summary generation.
    Validates visit and audio exist, creates job, returns immediately.
    """
    return await generate_visit_summary(user_id, visit_id)


@router.get("/visits/latest/status")
async def get_latest_visit_status_endpoint(user_id: str = Depends(get_user_id)):
    """
    Check whether the latest visit for this user is still processing.
    """
    from domain.ports.cache import get, set

    cache_key = f"visit_status:{user_id}"
    cached = get(cache_key)
    if cached is not None:
        return cached

    response = await get_latest_visit_status(user_id)
    set(cache_key, response, 5)
    return response


@router.get("/visits/{visit_id}/audio")
async def get_visit_audio_url_endpoint(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    return await get_visit_audio_url(user_id, visit_id)


@router.get("/visits/{visit_id}")
async def get_visit_metadata(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    """
    Get visit metadata from visits table.
    """
    return await get_visit_details(user_id, visit_id)


