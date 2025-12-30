"""
Download audio files from Google Cloud Storage by visit ID.

Usage:
    python download_audio.py <visit_id>
    
Example:
    python download_audio.py 123
    
This will download audio/visit_123.* to the audio/ folder.
"""

import os
import sys
from google.cloud import storage
from dotenv import load_dotenv
from pathlib import Path

# Load environment from parent directory
backend_dir = Path(__file__).parent.parent
load_dotenv(backend_dir / '.env')


def download_audio(visit_id, output_dir='audio'):
    """
    Download audio file from GCS by visit ID.
    
    Args:
        visit_id: The visit identifier
        output_dir: Directory to save the audio file
        
    Returns:
        str: Path to downloaded file, or None if failed
    """
    bucket_name = os.getenv('GCS_BUCKET_NAME')
    if not bucket_name:
        print("❌ GCS_BUCKET_NAME not found in .env")
        print("   Check: apps/backend/.env")
        return None
    
    try:
        # Initialize GCS client
        print(f"Connecting to GCS bucket: {bucket_name}")
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        
        # List files with this visit_id
        prefix = f'audio/{visit_id}'
        blobs = list(bucket.list_blobs(prefix=prefix))
        
        if not blobs:
            print(f"❌ No audio files found for visit_id: {visit_id}")
            print(f"   Searched for: gs://{bucket_name}/{prefix}*")
            print(f"\n💡 Try listing all files:")
            print(f"   gsutil ls gs://{bucket_name}/audio/")
            return None
        
        # Download first match
        blob = blobs[0]
        filename = os.path.basename(blob.name)
        
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        output_path = os.path.join(output_dir, filename)
        
        print(f"📥 Downloading: {blob.name}")
        print(f"   Size: {blob.size / 1024:.1f} KB")
        
        blob.download_to_filename(output_path)
        
        print(f"✓ Downloaded to: {output_path}")
        print(f"\n🎯 Use in notebook cell 4b:")
        print(f"   audio_file = '{filename}'")
        print(f"   transcript = transcribe_audio(audio_file)")
        
        return output_path
        
    except Exception as e:
        print(f"❌ Error downloading audio: {e}")
        print(f"\n💡 Troubleshooting:")
        print(f"   1. Check credentials: gcloud auth application-default login")
        print(f"   2. Verify bucket name in .env: {bucket_name}")
        print(f"   3. Check if file exists: gsutil ls gs://{bucket_name}/audio/")
        return None


def list_recent_files(limit=10):
    """List recent audio files in GCS."""
    bucket_name = os.getenv('GCS_BUCKET_NAME')
    if not bucket_name:
        print("❌ GCS_BUCKET_NAME not found in .env")
        return
    
    try:
        storage_client = storage.Client()
        bucket = storage_client.bucket(bucket_name)
        
        blobs = list(bucket.list_blobs(prefix='audio/', max_results=limit))
        
        if not blobs:
            print(f"No audio files found in gs://{bucket_name}/audio/")
            return
        
        print(f"\n📁 Recent audio files in {bucket_name}:")
        print("-" * 80)
        
        for blob in blobs:
            filename = os.path.basename(blob.name)
            size_kb = blob.size / 1024
            # Extract visit_id from filename (e.g., visit_123.webm -> 123)
            visit_id = filename.split('.')[0].replace('visit_', '')
            print(f"Visit ID: {visit_id:<10} File: {filename:<25} Size: {size_kb:.1f} KB")
        
        print("-" * 80)
        print(f"\n💡 To download: python download_audio.py <visit_id>")
        
    except Exception as e:
        print(f"❌ Error listing files: {e}")


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("📥 Audio Downloader for MediMinder")
        print("=" * 80)
        print("\nUsage:")
        print("  python download_audio.py <visit_id>")
        print("  python download_audio.py list           # List recent files")
        print("\nExamples:")
        print("  python download_audio.py 123")
        print("  python download_audio.py list")
        print("\n" + "=" * 80)
        
        # Show recent files by default
        list_recent_files()
        
    elif sys.argv[1].lower() == 'list':
        limit = int(sys.argv[2]) if len(sys.argv) > 2 else 20
        list_recent_files(limit)
        
    else:
        visit_id = sys.argv[1]
        download_audio(visit_id)

