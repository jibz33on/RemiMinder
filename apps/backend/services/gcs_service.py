import os
import traceback
from datetime import timedelta
from google.cloud import storage
from fastapi import UploadFile

async def upload_audio(file: UploadFile, visit_id: str) -> str:
    """
    Upload audio file to Google Cloud Storage with UBLA compatibility.
    Returns a signed URL for temporary access.

    Args:
        file: The uploaded audio file
        visit_id: Unique identifier for the visit

    Returns:
        str: Signed URL for accessing the uploaded audio file
    """
    try:
        # Get GCS configuration from environment
        bucket_name = os.getenv("GCS_BUCKET_NAME")
        if not bucket_name:
            raise ValueError("GCS_BUCKET_NAME environment variable not set")

        # Initialize GCS client
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)

        # Create unique filename using visit_id
        file_extension = os.path.splitext(file.filename)[1] if file.filename else ".wav"
        blob_name = f"audio/{visit_id}{file_extension}"

        # Create blob
        blob = bucket.blob(blob_name)

        # Upload file directly from the file object (UBLA-compatible)
        # Reset file pointer to beginning in case it was read before
        await file.seek(0)
        blob.upload_from_file(
            file.file,  # Use the underlying file object
            content_type=file.content_type or "audio/wav"
        )

        # Generate signed URL for read access (UBLA-compatible alternative to make_public)
        signed_url = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(hours=24),  # URL valid for 24 hours
            method="GET"
        )

        return signed_url

    except Exception as e:
        # Log full traceback for debugging
        error_details = traceback.format_exc()
        print(f"GCS upload error for visit {visit_id}: {str(e)}")
        print(f"Full traceback: {error_details}")
        raise Exception(f"GCS upload failed: {str(e)}")
