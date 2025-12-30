import logging
from datetime import datetime
from typing import List, Optional, Dict, Any

from fastapi import APIRouter, HTTPException, Depends, File, UploadFile

from schemas.schemas import VisitSummary, VisitSummaryPayload
from services.ai_service import generate_ai_summary
from services.db_service import (
    fetch_visit_transcript,
    fetch_visit_summary,
    insert_visit_summary,
    insert_visit_transcript,
    update_transcript_visit_id,
    fetch_all_visit_summaries,
    update_visit_audio_url,
    upsert_visit_audio_url,
    get_visit_audio_url,
    get_supabase_client,
)
from services.gcs_service import upload_audio
from utils.auth import get_current_user

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/api", tags=["Visit Summaries"])


def get_user_id(current_user=Depends(get_current_user)) -> str:
    """Extract user_id from authenticated user"""
    auth_uid = current_user["sub"]
    supabase = get_supabase_client()
    user_res = supabase.table("users").select("id").eq("auth_uid", auth_uid).execute()
    if not user_res.data:
        raise HTTPException(status_code=404, detail="User not found in database")
    return user_res.data[0]["id"]

@router.post("/generate-summary/{visit_id}", response_model=VisitSummaryPayload)
async def create_visit_summary(visit_id: str, user_id: str, transcript_id: str):
    visit = await fetch_visit_transcript(visit_id, user_id, transcript_id)
    if not visit or not visit.get("transcript_text"):
        raise HTTPException(status_code=404, detail="Transcript not found")

    ai_output = await generate_ai_summary({
        "transcript": visit["transcript_text"],
        "visit_id": visit_id,
        "user_id": user_id,
        "transcript_id": visit["transcript_id"]
    })

    await insert_visit_summary(visit_id, user_id, visit["transcript_id"], ai_output)

    return {
        "message": "Summary generated successfully",
        "data": {
            "visit_id": visit_id,
            "user_id": user_id,
            "transcript_id": transcript_id,
            **ai_output,
        }
    }

@router.get("/visit-summaries/{visit_id}", response_model=VisitSummary)
async def get_visit_summary(visit_id: int, user_id: int):
    row = await fetch_visit_summary(visit_id, user_id)
    if not row:
        raise HTTPException(status_code=404, detail="Summary not found")
    return row

@router.get("/visit-summaries")
async def get_all_summaries(user_id: str = Depends(get_user_id)):
    logger.info(f"Fetching visit summaries for user_id: {user_id}")
    summaries = await fetch_all_visit_summaries(user_id)
    logger.info(f"Found {len(summaries)} raw summaries from database")
    formatted_summaries = []

    for item in summaries:
        visit_data = item.get('visits', {})
        date_source = item.get('created_at')
        visit_dt = datetime.now() if not date_source else datetime.fromisoformat(date_source.replace('Z', '+00:00'))

        formatted_summaries.append({
            "id": item.get('visit_id'),
            "title": visit_data.get('title', 'Untitled Visit'),
            "status": visit_data.get('status', 'Completed'),
            "doctor": visit_data.get('doctor', 'N/A'),
            "specialty": visit_data.get('specialty', 'General'),
            "date": visit_dt.strftime("%b %d, %Y"),
            "time": visit_dt.strftime("%I:%M %p"),
            "duration": visit_data.get('duration', 'N/A'),
            "summary": item.get('summary', 'No summary available.'),
            "keyPoints": item.get('action_items', '').split(', ') if item.get('action_items') else [],
        })

    return formatted_summaries


@router.post("/visits/{visit_id}/audio/upload")
async def upload_audio_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    user_id: str = Depends(get_user_id)
):
    try:
        # Ensure visit exists to prevent foreign key errors during AI processing
        supabase = get_supabase_client()
        existing_visit = supabase.table("visits").select("id").eq("id", visit_id).execute()

        if not existing_visit.data:
            visit_data = {
                "id": visit_id,
                "user_id": user_id,
                "title": "Audio Visit",
                "status": "processing",
                "doctor": "Processing",
                "specialty": "Audio Analysis"
            }
            supabase.table("visits").insert(visit_data).execute()

        # Upload to GCS and save URL
        audio_url = await upload_audio(file, visit_id)
        db_result = await upsert_visit_audio_url(visit_id, user_id, audio_url)

        if db_result is None:
            raise HTTPException(
                status_code=500,
                detail="Audio uploaded to storage but failed to update visit record in database"
            )

        return {
            "message": "Audio uploaded successfully",
            "audio_url": audio_url,
            "expires_in": "24 hours"
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Audio upload failed: {str(e)}")


@router.post("/visits/{visit_id}/process-audio")
async def process_visit_audio(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    try:
        # Ensure visit exists to prevent foreign key errors
        supabase = get_supabase_client()
        existing_visit = supabase.table("visits").select("id").eq("id", visit_id).execute()

        if not existing_visit.data:
            visit_data = {
                "id": visit_id,
                "user_id": user_id,
                "title": "Audio Visit",
                "status": "processing",
                "doctor": "AI Processing",
                "specialty": "Audio Analysis"
            }
            supabase.table("visits").insert(visit_data).execute()
            logger.info(f"Created visit record {visit_id} for AI processing")

        # Process audio and save results
        from services.transcription_service import process_visit_audio as run_audio_processing
        result = await run_audio_processing(visit_id, user_id)

        transcript_record = await insert_visit_transcript(result["transcription"])
        if not transcript_record:
            raise HTTPException(status_code=500, detail="Failed to store transcript")

        transcript_id = transcript_record['transcript_id']
        await update_transcript_visit_id(transcript_id, visit_id, user_id)
        await insert_visit_summary(visit_id, user_id, transcript_id, result["ai_summary"])

        logger.info(f"Successfully processed audio for visit {visit_id}")

        return {
            "message": "Audio processed successfully",
            "visit_id": visit_id,
            "transcription": result["transcription"],
            "summary": result["ai_summary"]
        }

    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Audio processing failed for visit {visit_id}: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Audio processing failed: {str(e)}")


@router.get("/visits/{visit_id}/audio")
async def get_visit_audio_url_endpoint(
    visit_id: str,
    user_id: str = Depends(get_user_id)
):
    try:
        audio_url = await get_visit_audio_url(visit_id, user_id)
        if audio_url is None:
            raise HTTPException(status_code=404, detail="No audio found for this visit")

        return {
            "visit_id": visit_id,
            "audio_url": audio_url
        }

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to retrieve audio: {str(e)}")
