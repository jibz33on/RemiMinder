from domain.transcripts.repo import get_audio_gcs_url, get_transcript_text, save_raw_transcript


async def fetch_transcript_text(transcript_id: str) -> str:
    return await get_transcript_text(transcript_id)


async def fetch_audio_url(visit_id: str, user_id: str) -> str:
    return await get_audio_gcs_url(visit_id, user_id)


async def store_raw_transcript(
    visit_id: str,
    user_id: str,
    transcript: str,
    confidence: float | None = None,
    language: str | None = None,
) -> str:
    return await save_raw_transcript(
        visit_id=visit_id,
        user_id=user_id,
        transcript=transcript,
        confidence=confidence,
        language=language,
    )
