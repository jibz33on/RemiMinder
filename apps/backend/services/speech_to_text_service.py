import os
import openai
import asyncio
from typing import Optional, Dict, Any
import logging

logger = logging.getLogger(__name__)

class SpeechToTextService:
    """High-accuracy speech-to-text service using OpenAI Whisper"""

    def __init__(self):
        self.client = openai.OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

    async def transcribe_audio_file(self, audio_file_path: str) -> Optional[str]:
        """
        Transcribe audio file using OpenAI Whisper for maximum accuracy.
        Best for: Final transcriptions, medical terminology, accents.
        """
        try:
            if not os.path.exists(audio_file_path):
                logger.error(f"Audio file not found: {audio_file_path}")
                return None

            # Check file size (Whisper has limits)
            file_size = os.path.getsize(audio_file_path)
            if file_size > 25 * 1024 * 1024:  # 25MB limit
                logger.error(f"Audio file too large: {file_size} bytes")
                return None

            logger.info(f"Starting Whisper transcription for: {audio_file_path}")

            with open(audio_file_path, "rb") as audio_file:
                start_time = asyncio.get_event_loop().time()

                transcript = self.client.audio.transcriptions.create(
                    model="whisper-1",
                    file=audio_file,
                    response_format="text",
                    language="en",  # Optimize for English medical conversations
                    temperature=0  # More deterministic results
                )

                end_time = asyncio.get_event_loop().time()
                processing_time = end_time - start_time

                logger.info(f"Whisper transcription completed in {processing_time:.2f}s")

            return transcript.strip() if transcript else None

        except Exception as e:
            logger.error(f"Whisper transcription failed: {str(e)}")
            return None

    async def compare_transcriptions(self, mobile_transcript: str, audio_file_path: str) -> Dict[str, Any]:
        """
        Compare mobile STT with Whisper for quality assurance.
        Returns both transcripts and confidence metrics.
        """
        whisper_transcript = await self.transcribe_audio_file(audio_file_path)

        return {
            "mobile_transcript": mobile_transcript,
            "whisper_transcript": whisper_transcript,
            "transcripts_match": self._calculate_similarity(mobile_transcript, whisper_transcript or ""),
            "whisper_confidence": self._estimate_confidence(whisper_transcript),
            "recommended_transcript": whisper_transcript or mobile_transcript
        }

    def _calculate_similarity(self, text1: str, text2: str) -> float:
        """Simple similarity calculation (you could use more sophisticated NLP here)"""
        if not text1 or not text2:
            return 0.0

        # Basic word overlap similarity
        words1 = set(text1.lower().split())
        words2 = set(text2.lower().split())

        intersection = words1.intersection(words2)
        union = words1.union(words2)

        return len(intersection) / len(union) if union else 0.0

    def _estimate_confidence(self, transcript: str) -> float:
        """Estimate confidence based on transcript characteristics"""
        if not transcript:
            return 0.0

        # Simple heuristics for confidence
        confidence = 0.8  # Base confidence

        # Longer transcripts tend to be more accurate
        if len(transcript.split()) > 50:
            confidence += 0.1

        # Medical terminology boosts confidence
        medical_terms = ['mg', 'ml', 'blood', 'pressure', 'heart', 'lung', 'pain']
        if any(term in transcript.lower() for term in medical_terms):
            confidence += 0.05

        return min(confidence, 1.0)
