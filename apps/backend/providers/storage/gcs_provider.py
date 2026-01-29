"""
GCS storage provider adapter.
"""

from providers.storage.gcs_storage import (
    build_image_reference,
    upload_audio,
    upload_image,
)

__all__ = ["upload_audio", "upload_image", "build_image_reference"]
