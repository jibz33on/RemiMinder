"""
Simple synchronous Speech-to-Text pipeline for audio files.
Reads audio from Google Cloud Storage, processes with Google STT, returns transcript.
"""

import logging
import os
import tempfile
import subprocess
from typing import Dict, Any, List
from google.cloud import speech, storage

logger = logging.getLogger(__name__)

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


def convert_m4a_to_wav(input_path: str, output_path: str) -> None:
    """
    Convert m4a (AAC) audio to WAV (LINEAR16, 16kHz, mono) using system ffmpeg.
    """
    command = [
        "ffmpeg",
        "-y",              # overwrite output
        "-i", input_path,  # input file
        "-ac", "1",        # mono
        "-ar", "16000",    # 16kHz sample rate
        "-acodec", "pcm_s16le",  # LINEAR16 codec
        output_path,       # output file
    ]

    subprocess.run(
        command,
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


async def run_audio_stt_pipeline(visit_id: str, firebase_uid: str, language: str = "en") -> Dict[str, Any]:
    try:
        logger.info(f"🔍 [STT] Starting STT pipeline for visit {visit_id} with language='{language}'")

        # Step 1: Resolve user UUID
        from services.db_service import get_user_uuid, get_audio_gcs_url

        user_uuid = await get_user_uuid(firebase_uid)

        # Step 2: Validate audio exists in DB (guard)
        audio_url = await get_audio_gcs_url(visit_id, user_uuid)

        bucket_name = os.getenv("GCS_BUCKET_NAME")
        if not bucket_name:
            raise RuntimeError("GCS_BUCKET_NAME environment variable not set")

        m4a_blob_name = f"audio/{visit_id}.m4a"

        logger.info(f"Starting STT for visit {visit_id}")
        logger.info(f"Converting {m4a_blob_name} -> WAV")
        logger.debug(f"Audio URL (DB): {audio_url}")

        # Step 3: Download m4a, convert to wav, and upload to GCS temp location
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)

        m4a_temp_path = None
        wav_temp_path = None
        stt_temp_blob_name = f"stt_temp/{visit_id}.wav"

        try:
            # Download m4a file to temp location
            m4a_blob = bucket.blob(m4a_blob_name)
            with tempfile.NamedTemporaryFile(suffix='.m4a', delete=False, dir='/tmp') as m4a_temp:
                m4a_blob.download_to_file(m4a_temp)
                m4a_temp_path = m4a_temp.name

            # Convert to WAV using system ffmpeg
            with tempfile.NamedTemporaryFile(suffix='.wav', delete=False, dir='/tmp') as wav_temp:
                wav_temp_path = wav_temp.name

            convert_m4a_to_wav(m4a_temp_path, wav_temp_path)

            # Upload converted WAV to GCS temp location
            stt_blob = bucket.blob(stt_temp_blob_name)
            stt_blob.upload_from_filename(wav_temp_path)

            logger.info(f"Uploaded converted WAV to GCS: {stt_temp_blob_name}")

        except Exception as e:
            # Clean up temp files and GCS blob on error
            if m4a_temp_path and os.path.exists(m4a_temp_path):
                os.unlink(m4a_temp_path)
            if wav_temp_path and os.path.exists(wav_temp_path):
                os.unlink(wav_temp_path)
            # Clean up GCS temp blob if it exists
            try:
                temp_blob = bucket.blob(stt_temp_blob_name)
                if temp_blob.exists():
                    temp_blob.delete()
            except:
                pass  # Ignore cleanup errors
            raise RuntimeError(f"Audio conversion/upload failed: {e}")
        finally:
            # Always clean up local temp files
            if m4a_temp_path and os.path.exists(m4a_temp_path):
                os.unlink(m4a_temp_path)
            if wav_temp_path and os.path.exists(wav_temp_path):
                os.unlink(wav_temp_path)

        # Step 4: Configure STT using GCS URI
        speech_client = speech.SpeechClient()
        gcs_wav_uri = f"gs://{bucket_name}/{stt_temp_blob_name}"

        audio = speech.RecognitionAudio(uri=gcs_wav_uri)

        # Map language code for STT
        language_code = LANGUAGE_MAP.get(language, "en-US")
        logger.info(f"🔍 [STT] Language mapping: input='{language}', available_keys={list(LANGUAGE_MAP.keys())}, result='{language_code}'")
        logger.info(f"🔍 [STT] Starting Google STT with language_code='{language_code}' for visit {visit_id}")

        config = speech.RecognitionConfig(
            encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
            language_code=language_code,
            enable_automatic_punctuation=True,
        )

        # Step 5: Run long-running recognition
        operation = speech_client.long_running_recognize(config=config, audio=audio)

        # Wait for completion (up to 30 minutes for very long recordings)
        response = operation.result(timeout=1800)

        # Clean up GCS temp file after successful processing
        try:
            temp_blob = bucket.blob(stt_temp_blob_name)
            if temp_blob.exists():
                temp_blob.delete()
                logger.info(f"Cleaned up GCS temp file: {stt_temp_blob_name}")
        except Exception as cleanup_error:
            logger.warning(f"Failed to clean up GCS temp file {stt_temp_blob_name}: {cleanup_error}")
            # Don't fail the whole process for cleanup issues

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
            "language": language_code,
        }

    except Exception:
        logger.exception(f"STT pipeline failed for visit {visit_id}")
        raise
