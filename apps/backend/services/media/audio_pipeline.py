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


async def run_audio_stt_pipeline(visit_id: str, firebase_uid: str) -> Dict[str, Any]:
    try:
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

        # Step 3: Download m4a and convert to wav locally
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)

        m4a_temp_path = None
        wav_temp_path = None

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

            # Step 4: Configure STT for local WAV file
            speech_client = speech.SpeechClient()

            # Read WAV file content for STT
            with open(wav_temp_path, 'rb') as wav_file:
                wav_content = wav_file.read()

            audio = speech.RecognitionAudio(content=wav_content)

            # Configure for LINEAR16 WAV
            config = speech.RecognitionConfig(
                encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
                sample_rate_hertz=16000,
                language_code="en-US",
                enable_automatic_punctuation=True,
            )

        except Exception as e:
            # Clean up temp files on error
            if m4a_temp_path and os.path.exists(m4a_temp_path):
                os.unlink(m4a_temp_path)
            if wav_temp_path and os.path.exists(wav_temp_path):
                os.unlink(wav_temp_path)
            raise RuntimeError(f"Audio conversion failed: {e}")
        finally:
            # Always clean up temp files
            if m4a_temp_path and os.path.exists(m4a_temp_path):
                os.unlink(m4a_temp_path)
            if wav_temp_path and os.path.exists(wav_temp_path):
                os.unlink(wav_temp_path)

        # Step 5: Run recognition
        response = speech_client.recognize(config=config, audio=audio)

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
            f"STT completed for visit {visit_id}: "
            f"{len(transcript)} chars, avg confidence={confidence}"
        )

        return {
            "transcript": transcript,
            "confidence": confidence,
            "language": "en-US",
        }

    except Exception:
        logger.exception(f"STT pipeline failed for visit {visit_id}")
        raise
