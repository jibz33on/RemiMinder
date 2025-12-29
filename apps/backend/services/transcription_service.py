import logging
import os
import tempfile

import requests
from typing import Dict, Any

logger = logging.getLogger(__name__)

async def transcribe_audio_from_url(audio_url: str) -> str:
    """Download audio from GCS signed URL and transcribe it using OpenAI Whisper."""
    openai_key = os.getenv("OPENAI_API_KEY")

    if not openai_key:
        logger.warning("OPENAI_API_KEY not set. Using mock transcription for testing.")
        return (
            "This is a mock transcription. The doctor discussed the patient's recent lab results "
            "and recommended continuing the current medication regimen. The patient mentioned "
            "feeling better overall but experiencing some mild side effects from the medication."
        )

    # Create OpenAI client
    from openai import OpenAI
    client = OpenAI(api_key=openai_key)

    try:
        # Download audio from GCS signed URL
        logger.info("Downloading audio from GCS...")
        response = requests.get(audio_url)
        response.raise_for_status()

        # Save to temporary file
        with tempfile.NamedTemporaryFile(delete=False, suffix=".m4a") as temp_file:
            temp_file.write(response.content)
            temp_file_path = temp_file.name

        # Transcribe with OpenAI Whisper
        logger.info("Transcribing audio with OpenAI Whisper...")
        with open(temp_file_path, "rb") as audio_file:
            transcription = client.audio.transcriptions.create(
                model="gpt-4o-transcribe",
                file=audio_file,
                response_format="text"
            )

        # Clean up temporary file
        os.unlink(temp_file_path)

        logger.info("Transcription completed successfully")
        return transcription

    except Exception as e:
        logger.error(f"Transcription failed: {str(e)}")
        raise Exception(f"Failed to transcribe audio: {str(e)}")


async def process_visit_audio(visit_id: str, user_id: str) -> Dict[str, Any]:
    """Complete audio processing pipeline: transcribe with Whisper + generate AI summary with Gemini."""
    try:
        # Get audio URL from database
        from .db_service import get_visit_audio_url
        audio_url = await get_visit_audio_url(visit_id, user_id)

        if not audio_url:
            raise Exception(f"No audio found for visit {visit_id}")

        # Transcribe the audio
        logger.info(f"Processing audio for visit {visit_id}")
        transcription = await transcribe_audio_from_url(audio_url)

        # Generate AI summary using existing Gemini service
        from .ai_service import generate_ai_summary
        ai_summary = await generate_ai_summary({
            "transcript": transcription,
            "visit_id": visit_id,
            "user_id": user_id,
            "transcript_id": None
        })

        return {
            "transcription": transcription,
            "ai_summary": ai_summary,
            "visit_id": visit_id
        }

    except Exception as e:
        logger.error(f"Audio processing failed for visit {visit_id}: {str(e)}")
        raise Exception(f"Audio processing failed: {str(e)}")
