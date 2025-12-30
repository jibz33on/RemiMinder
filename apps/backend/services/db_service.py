import logging
import random
from typing import List, Optional, Dict, Any

from .supabase_client import get_supabase_client

logger = logging.getLogger(__name__)

async def get_doctor() -> Optional[Dict[str, Any]]:
    """Get a random doctor from the database."""
    supabase = get_supabase_client()
    response = supabase.table("doctors").select("name, specialty").execute()

    if not response.data:
        logger.warning("No doctors found in database")
        return None

    return random.choice(response.data)

async def fetch_visit_transcript(visit_id: str, user_id: str, transcript_id: str) -> Optional[Dict[str, Any]]:
    """Fetch transcript text for a specific visit."""
    supabase = get_supabase_client()

    response = (
        supabase.table("visits")
        .select("doctor, title, status, specialty, visit_transcripts(transcript_text, audio_url)")
        .eq("id", visit_id)
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    data = response.data
    if not data or not data.get("visit_transcripts"):
        return None

    transcript = data["visit_transcripts"]
    return {
        "doctor": data.get("doctor"),
        "transcript_id": transcript_id,  # Use parameter instead of data.get("transcript_id")
        "transcript_text": transcript.get("transcript_text"),
        "audio_url": transcript.get("audio_url"),
    }

async def fetch_visit_summary(visit_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """Fetch a single visit summary with related visit details."""
    supabase = get_supabase_client()

    response = (
        supabase.table("visit_summaries")
        .select("*, visits(title, status, doctor, specialty, duration, created_at)")
        .eq("id", visit_id)
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    data = response.data
    if not data:
        return None

    visit_info = data.get("visits") or {}

    # Parse action items from comma-separated string if needed
    action_items = data.get("action_items", [])
    if isinstance(action_items, str):
        action_items = [item.strip() for item in action_items.split(",") if item.strip()]

    return {
        "id": data.get("id"),
        "title": visit_info.get("title"),
        "status": visit_info.get("status"),
        "doctor": visit_info.get("doctor"),
        "specialty": visit_info.get("specialty"),
        "duration": visit_info.get("duration"),
        "created_at": visit_info.get("created_at"),
        "summary": data.get("summary"),
        "keyPoints": action_items,
    }


async def fetch_all_visit_summaries(user_id: str) -> List[Dict[str, Any]]:
    """Fetch all summaries for a patient (no transcript)."""
    logger.info(f"Querying visit_summaries for user_id: {user_id}")
    supabase = get_supabase_client()

    response = (
        supabase.table("visit_summaries")
        .select("*, visits(title, status, doctor, specialty, duration, created_at)")
        .eq("user_id", user_id)
        .order("created_at", desc=True)
        .execute()
    )

    result = response.data or []
    logger.info(f"Query returned {len(result)} visit summaries")
    if result:
        logger.info(f"Sample summary IDs: {[s.get('id') for s in result[:3]]}")
    return result

def _list_to_comma_separated(data_list: list) -> str:
    if isinstance(data_list, tuple):
        data_list = data_list[0] if data_list else []
    
    if not isinstance(data_list, list) or not data_list:
        return ""
        
    return ", ".join(data_list)

async def insert_visit_summary(
    visit_id: str,
    user_id: str,
    transcript_id: str,
    summary_data: dict
) -> Optional[Dict[str, Any]]:
    """Insert visit summary data into database."""
    logger.info(f"Inserting visit summary for visit_id: {visit_id}, user_id: {user_id}")
    supabase = get_supabase_client()

    # Convert lists to comma-separated strings for storage
    # Note: reminders are handled separately by insert_ai_reminders in ai_service.py
    data = {
        "visit_id": visit_id,
        "user_id": user_id,
        "transcript_id": transcript_id,
        "summary": summary_data.get("summary"),
        "action_items": _list_to_comma_separated(summary_data.get("action_items", [])),
        "questions_next_visit": _list_to_comma_separated(summary_data.get("questions_next_visit", [])),
        "key_diagnoses": _list_to_comma_separated(summary_data.get("key_diagnoses", [])),
        "medications": _list_to_comma_separated(summary_data.get("medications", [])),
    }

    logger.info(f"Summary data to insert: summary length={len(data.get('summary', ''))}")

    # Update visit title
    title = summary_data.get("title", "New Recorded Visit")
    await update_visit_title(visit_id, user_id, title)

    response = supabase.table("visit_summaries").insert(data).execute()
    if response.data:
        logger.info(f"Visit summary inserted successfully with ID: {response.data[0].get('id')}")
        return response.data[0]
    else:
        logger.error("Visit summary insertion returned no data")
        return None


async def insert_visit_transcript(transcript_text: str) -> Optional[Dict[str, Any]]:
    """Inserts a new transcript and returns its ID."""
    supabase = get_supabase_client()
    response = supabase.table("visit_transcripts").insert({"transcript_text": transcript_text}).execute()
    return response.data[0] if response.data else None

async def insert_initial_visit(user_id: str, transcript_id: str) -> Optional[Dict[str, Any]]:
    """Create the initial visit record."""
    supabase = get_supabase_client()

    # Get random doctor or use defaults
    doctor = await get_doctor()
    doctor_name = doctor["name"] if doctor else "General Physician"
    doctor_specialty = doctor["specialty"] if doctor else "General Practice"

    data = {
        "user_id": user_id,
        "transcript_id": transcript_id,
        "title": "New Recorded Visit",
        "status": "pending",
        "doctor": doctor_name,
        "specialty": doctor_specialty,
    }

    response = supabase.table("visits").insert(data).execute()
    return response.data[0] if response.data else None

async def update_visit_title(visit_id: str, user_id: str, new_title: str) -> Optional[Dict[str, Any]]:
    """Update visit title."""
    supabase = get_supabase_client()

    response = (
        supabase.table("visits")
        .update({"title": new_title})
        .eq("id", visit_id)
        .eq("user_id", user_id)
        .execute()
    )

    if response.data:
        logger.info(f"Updated visit {visit_id} title to: {new_title}")
        return response.data[0]

    logger.warning(f"No visit found with id {visit_id}")
    return None

async def update_transcript_visit_id(transcript_id: str, visit_id: str, user_id: str) -> Optional[Dict[str, Any]]:
    """Update visit_transcripts record to link it to a specific visit_id."""
    supabase = get_supabase_client()
    try:
        response = (
            supabase.table("visit_transcripts")
            .update({"visit_id": visit_id, "user_id": user_id})
            .eq("transcript_id", transcript_id)
            .execute()
        )
        return response.data[0] if response.data else None
    except Exception as e:
        logger.error(f"Error updating transcript visit_id: {e}")
        return None


async def update_visit_audio_url(visit_id: str, audio_url: str) -> Optional[Dict[str, Any]]:
    """Update audio_url in visit_transcripts table for a specific visit."""
    supabase = get_supabase_client()
    try:
        response = (
            supabase.table("visit_transcripts")
            .update({"audio_url": audio_url})
            .eq("visit_id", visit_id)
            .execute()
        )
        return response.data[0] if response.data else None
    except Exception as e:
        logger.error(f"Error updating audio_url for visit {visit_id}: {e}")
        return None


async def upsert_visit_audio_url(visit_id: str, user_id: str, audio_url: str) -> Optional[Dict[str, Any]]:
    """Insert or update audio_url in visit_transcripts table. Creates record if it doesn't exist."""
    supabase = get_supabase_client()
    try:
        # First try to update existing record
        response = (
            supabase.table("visit_transcripts")
            .update({"audio_url": audio_url})
            .eq("visit_id", visit_id)
            .execute()
        )

        # If no record was updated, create a new one
        if not response.data:
            response = (
                supabase.table("visit_transcripts")
                .insert({
                    "visit_id": visit_id,
                    "user_id": user_id,
                    "audio_url": audio_url
                })
                .execute()
            )

        return response.data[0] if response.data else None
    except Exception as e:
        logger.error(f"Error upserting audio_url for visit {visit_id}: {e}")
        return None


async def get_visit_audio_url(visit_id: str, user_id: str) -> Optional[str]:
    """Fetch audio_url for a specific visit from visit_transcripts table."""
    supabase = get_supabase_client()
    try:
        response = (
            supabase.table("visit_transcripts")
            .select("audio_url")
            .eq("visit_id", visit_id)
            .eq("user_id", user_id)
            .single()
            .execute()
        )

        if response.data and response.data.get("audio_url"):
            return response.data["audio_url"]

        return None
    except Exception as e:
        logger.error(f"Error fetching audio_url for visit {visit_id}: {e}")
        return None


#-------------------------------------------------------------#
# AI
#-------------------------------------------------------------#
async def log_ai_usage(data: Dict) -> None:
    """Log AI usage with safety check for visit existence."""
    supabase = get_supabase_client()

    # Safety check: ensure visit exists before logging to prevent foreign key errors
    visit_id = data.get("visit_id")
    if visit_id:
        visit_check = supabase.table("visits").select("id").eq("id", visit_id).execute()
        if not visit_check.data:
            logger.warning(f"Skipping AI usage logging for visit {visit_id} - visit not found")
            return

    supabase.table("ai_usage").insert(data).execute()



#-------------------------------------------------------------#
# REMINDERS
#-------------------------------------------------------------#
def get_prompt_text_supabase(category: str, limit: int = 2) -> tuple[str, list]:
    """Get prompt text and examples from prompt bank and best examples tables."""
    supabase = get_supabase_client()
    examples = []

    try:
        # Get base prompt from prompt_bank
        prompt_bank_data = (
            supabase.table("prompt_bank")
            .select("prompt_text, example_input, example_output")
            .eq("prompt_category", category)
            .order("rating", desc=True)
            .order("created_at", desc=True)
            .limit(1)
            .execute()
        ).data

        base_prompt = ""
        if prompt_bank_data:
            base_prompt_entry = prompt_bank_data[0]
            base_prompt = base_prompt_entry['prompt_text']
            base_prompt_entry['source_table'] = 'prompt_bank'
            examples.append(base_prompt_entry)

        # Get additional examples from best_examples if needed
        if len(examples) < limit:
            best_examples_data = (
                supabase.table("best_examples")
                .select("example_input, example_output")
                .eq("category", category)
                .order("created_at", desc=True)
                .limit(1)
                .execute()
            ).data

            if best_examples_data:
                best_example = best_examples_data[0]
                best_example['source_table'] = 'best_examples'

                # Avoid duplicates
                if not examples or best_example['example_input'] != examples[0]['example_input']:
                    examples.append(best_example)

    except Exception as e:
        logger.warning(f"Error fetching prompt bank data: {e}")
        base_prompt = ""

    return base_prompt, examples
