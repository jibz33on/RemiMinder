# Audio Files Folder

Place your audio recordings here for testing.

## Supported Formats
- mp3, mp4, wav, m4a, webm, mpeg

## Quick Start: Download from GCS

### Easiest Way (Python Script):
```bash
cd /Users/jibinkunjumon/developments/MediMinder/apps/backend/experiments

# List recent audio files
python download_audio.py list

# Download specific visit
python download_audio.py 123
```

### Alternative: Web Console
1. Go to https://console.cloud.google.com/storage
2. Find your bucket → audio folder
3. Download the file
4. Move to this folder

**📖 Full guide:** See `DOWNLOAD_FROM_GCS.md` for all methods

## Example

```python
# In notebook cell 4b:
audio_file = 'visit_123.webm'
transcript = transcribe_audio(audio_file)
```

## Privacy Note

⚠️ **Delete audio files after testing** - they contain PHI (patient health information)

```bash
# Clean up after testing
rm *.webm *.mp3 *.wav
```

Files in this folder are gitignored and won't be committed.

