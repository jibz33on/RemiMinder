"""
Simple synchronous Speech-to-Text pipeline for audio files.
Reads audio from Google Cloud Storage, processes with Google STT, returns transcript.
"""

import os
from typing import Dict, Any, List
from google.cloud import speech

from domain.ports.logging import get_logger

logger = get_logger()

# Language mapping for Google STT
LANGUAGE_MAP = {
    "en": "en-US",
    "es": "es-ES",
    "fr": "fr-FR",
    "de": "de-DE",
    "ar": "ar-SA",
    "hi": "hi-IN",
    "zh": "zh-CN"
}


def _parse_gcs_uri(gcs_uri: str) -> tuple[str, str]:
    if not gcs_uri.startswith("gs://"):
        raise ValueError(f"Invalid GCS URI: {gcs_uri}")
    path = gcs_uri[len("gs://"):]
    parts = path.split("/", 1)
    if len(parts) != 2 or not parts[0] or not parts[1]:
        raise ValueError(f"Invalid GCS URI: {gcs_uri}")
    return parts[0], parts[1]


async def run_audio_stt_pipeline(
    visit_id: str,
    external_auth_id: str,
    language: str = "en",
) -> Dict[str, Any]:
    try:
        logger.info(f"🔍 [STT] Starting STT pipeline for visit {visit_id} with language='{language}'")

        # Step 1: Resolve user UUID
        from domain.users.repo import get_user_uuid
        from domain.transcripts.repo import get_canonical_audio_path

        user_uuid = await get_user_uuid(external_auth_id)

        # Step 2: Validate canonical audio exists in DB (guard)
        canonical_audio_path = await get_canonical_audio_path(visit_id, user_uuid)
        bucket_name, object_name = _parse_gcs_uri(canonical_audio_path)

        logger.info(f"Starting STT for visit {visit_id}")
        logger.info(f"Converting {object_name} -> WAV")
        logger.info("Canonical audio path (DB) resolved")

        # Step 3: Configure STT using canonical GCS URI
        speech_client = speech.SpeechClient()
        audio = speech.RecognitionAudio(uri=canonical_audio_path)

        config = speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            sample_rate_hertz=16000,
            language_code=language,
            enable_automatic_punctuation=False,
            use_enhanced=False,
        )

        # Step 5: Run long-running recognition
        operation = speech_client.long_running_recognize(config=config, audio=audio)

        # Wait for completion (up to 30 minutes for very long recordings)
        response = operation.result(timeout=1800)

        logger.info("STT job completed")

        if not response.results:
            raise ValueError("No speech detected in audio file")

        # Step 6: Aggregate results
        transcript_parts: List[str] = []
        confidence_values: List[float] = []

        for result in response.results:
            if result.alternatives:
                alt = result.alternatives[0]
                transcript_parts.append(alt.transcript)
                confidence_values.append(alt.confidence)

        transcript = " ".join(transcript_parts)
        confidence = (
            sum(confidence_values) / len(confidence_values)
            if confidence_values
            else None
        )

        logger.info(
            f"🔍 [STT] STT completed for visit {visit_id}: "
            f"{len(transcript)} chars, avg confidence={confidence}"
        )
        logger.info(f"🔍 [STT] Sample transcript text: '{transcript[:200]}...'")

        return {
            "transcript": transcript,
            "confidence": confidence,
            "language": language,
            "stt_engine": "google_stt",
        }

    except Exception:
        logger.exception(f"STT pipeline failed for visit {visit_id}")
        raise
