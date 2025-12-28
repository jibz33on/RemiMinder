#backend\route\visit_summary.py
from fastapi import APIRouter, HTTPException, Depends, File, UploadFile
from schemas.schemas import VisitSummary, VisitSummaryPayload
from services.db_service import (
    fetch_visit_transcript,
    fetch_visit_summary,
    insert_visit_summary,
    fetch_all_visit_summaries,
    update_visit_audio_url,
    upsert_visit_audio_url,
)
from services.ai_service import generate_ai_summary
from services.gcs_service import upload_audio
from services.db_service import get_supabase_client
from utils.auth import get_current_user
from datetime import datetime, timezone
from typing import List, Optional, Dict, Any

router = APIRouter(prefix="/api", tags=["Visit Summaries"])

@router.post("/generate-summary/{visit_id}", response_model=VisitSummaryPayload)
async def create_visit_summary(visit_id: str, user_id: str, transcript_id: str):

    visit = await fetch_visit_transcript(
        visit_id = visit_id,
        user_id = user_id,
        transcript_id = transcript_id,
    )
    if not visit or not visit.get("transcript_text"):
        raise HTTPException(status_code=404, detail="Transcript not found")
    
    ai_output = await generate_ai_summary({"transcript": visit["transcript_text"], "visit_id": visit_id, 
                                       "user_id": user_id, "transcript_id": visit["transcript_id"]})
    
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
    """Get single visit summary"""
    row = await fetch_visit_summary(visit_id, user_id)
    if not row:
        raise HTTPException(status_code=404, detail="Summary not found")
    return row

@router.get("/visit-summaries")
async def get_all_summaries(current_user=Depends(get_current_user)):
    """Get all summaries for patient (for Visit History page)"""
    # Get internal user_id from auth_uid
    supabase = get_supabase_client()
    auth_uid = current_user["sub"]

    user_res = supabase.table("users").select("id").eq("auth_uid", auth_uid).execute()
    if not user_res.data:
        raise HTTPException(status_code=404, detail="User not found in database")

    user_id = user_res.data[0]["id"]

    summaries = await fetch_all_visit_summaries(user_id)
    formatted_summaries = []
    for item in summaries:
        visit_data = item.get('visits', {})

        date_source = item.get('created_at')

        if not date_source:
            visit_dt = datetime.now()
        else:
            visit_dt = datetime.fromisoformat(date_source.replace('Z', '+00:00'))

        formatted_summaries.append({
            "id": item.get('visit_id'),
            "title": visit_data.get('title', 'Untitled Visit'),
            "status": visit_data.get('status', 'Completed'),
            "doctor": visit_data.get('doctor', 'N/A'),
            "specialty": visit_data.get('specialty', 'General'),
            "date": visit_dt.strftime("%b %d, %Y"),  # e.g., Oct 10, 2025
            "time": visit_dt.strftime("%I:%M %p"),   # e.g., 2:30 PM
            "duration": visit_data.get('duration', 'N/A'),
            "summary": item.get('summary', 'No summary available.'),
            # MAPPING: action_items (from DB) -> keyPoints (for Frontend)
            "keyPoints": item.get('action_items', '').split(', ') if item.get('action_items') else [],
        })

    return formatted_summaries


@router.post("/visits/{visit_id}/audio/upload")
async def upload_audio_for_visit(
    visit_id: str,
    file: UploadFile = File(...),
    current_user=Depends(get_current_user)
):
    """
    Upload audio file to GCS (UBLA-compatible) and save the signed URL in visit_transcripts table.
    Creates visit_transcripts record if it doesn't exist.
    Returns success message with signed audio URL (valid for 24 hours).
    """
    try:
        # Get user_id from authenticated user
        auth_uid = current_user["sub"]
        supabase = get_supabase_client()
        user_res = supabase.table("users").select("id").eq("auth_uid", auth_uid).execute()
        if not user_res.data:
            raise HTTPException(status_code=404, detail="User not found in database")
        user_id = user_res.data[0]["id"]

        # Upload file to GCS first
        audio_url = await upload_audio(file, visit_id)

        # Save the audio URL in database (create record if it doesn't exist)
        try:
            db_result = await upsert_visit_audio_url(visit_id, user_id, audio_url)
            if db_result is None:
                raise HTTPException(
                    status_code=500,
                    detail="Audio uploaded to storage but failed to update visit record in database"
                )
        except Exception as db_error:
            raise HTTPException(
                status_code=500,
                detail=f"Audio uploaded to storage but database update failed: {str(db_error)}"
            )

        return {
            "message": "Audio uploaded successfully",
            "audio_url": audio_url,
            "expires_in": "24 hours"  # Signed URL expiration info
        }

    except HTTPException:
        # Re-raise HTTP exceptions as-is
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Audio upload failed: {str(e)}")
