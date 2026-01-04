import os
import traceback
import uuid
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


async def upload_image(file: UploadFile, visit_id: str) -> dict:
    """
    Upload image file to Google Cloud Storage with UBLA compatibility.
    Returns signed URL and metadata for temporary access.

    Args:
        file: The uploaded image file
        visit_id: Unique identifier for the visit

    Returns:
        dict: Contains signed URL, file path, and content type
    """
    try:
        # Get GCS configuration from environment
        bucket_name = os.getenv("GCS_BUCKET_NAME")
        if not bucket_name:
            raise ValueError("GCS_BUCKET_NAME environment variable not set")

        # Initialize GCS client
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)

        # Generate unique filename within visit directory
        file_uuid = str(uuid.uuid4())
        file_extension = os.path.splitext(file.filename)[1] if file.filename else ".jpg"
        blob_name = f"images/{visit_id}/{file_uuid}{file_extension}"

        # Create blob
        blob = bucket.blob(blob_name)

        # Determine content type for images
        content_type = file.content_type
        if not content_type or not content_type.startswith('image/'):
            # Fallback to common image types based on extension
            if file_extension.lower() in ['.jpg', '.jpeg']:
                content_type = "image/jpeg"
            elif file_extension.lower() == '.png':
                content_type = "image/png"
            elif file_extension.lower() == '.heic':
                content_type = "image/heic"
            elif file_extension.lower() == '.webp':
                content_type = "image/webp"
            else:
                content_type = "image/jpeg"  # Default fallback

        # Upload file directly from the file object (UBLA-compatible)
        # Reset file pointer to beginning in case it was read before
        await file.seek(0)
        blob.upload_from_file(
            file.file,  # Use the underlying file object
            content_type=content_type
        )

        # Generate signed URL for read access (UBLA-compatible alternative to make_public)
        signed_url = blob.generate_signed_url(
            version="v4",
            expiration=timedelta(hours=24),  # URL valid for 24 hours
            method="GET"
        )

        return {
            "signed_url": signed_url,
            "blob_name": blob_name,
            "content_type": content_type,
            "file_size": blob.size
        }

    except Exception as e:
        # Log full traceback for debugging
        error_details = traceback.format_exc()
        print(f"GCS image upload error for visit {visit_id}: {str(e)}")
        print(f"Full traceback: {error_details}")
        raise Exception(f"GCS image upload failed: {str(e)}")
