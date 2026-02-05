"""
Minimal Gemini client for Vertex AI (infra only).
"""

import os
from typing import List, Optional, Sequence, Union

from google.cloud import aiplatform
from vertexai.generative_models import GenerativeModel  # type: ignore

from domain.ports.logging import get_logger

logger = get_logger()

DEFAULT_MODEL = "gemini-2.5-flash"
DEFAULT_REGION = "us-central1"

PromptInput = Union[str, Sequence[str]]


class GeminiClient:
    def __init__(
        self,
        *,
        project_id: Optional[str] = None,
        location: Optional[str] = None,
        model_name: Optional[str] = None,
        timeout_seconds: int = 30,
    ) -> None:
        self.project_id = project_id or os.getenv("GCP_PROJECT")
        if not self.project_id:
            raise ValueError("GCP_PROJECT environment variable must be set")
        self.location = location or os.getenv("GCP_LOCATION") or DEFAULT_REGION
        self.model_name = model_name or DEFAULT_MODEL
        self.timeout_seconds = timeout_seconds

        aiplatform.init(project=self.project_id, location=self.location)
        self._model = GenerativeModel(self.model_name)

    def generate_text(
        self,
        *,
        prompt: Optional[str] = None,
        messages: Optional[PromptInput] = None,
        temperature: Optional[float] = None,
    ) -> str:
        if (prompt is None) == (messages is None):
            raise ValueError("Provide exactly one of prompt or messages")
        try:
            payload: Union[str, Sequence[str]]
            if prompt is not None:
                payload = prompt
            else:
                payload = messages if isinstance(messages, (list, tuple)) else [str(messages)]

            generation_config = None
            if temperature is not None:
                generation_config = {"temperature": float(temperature)}
            response = self._model.generate_content(payload, generation_config=generation_config)
            return (response.text or "").strip()
        except Exception as exc:
            logger.error(f"Gemini call failed: {exc}")
            raise RuntimeError(f"Gemini call failed: {exc}") from exc


def smoke_test_gemini() -> None:
    """
    Connectivity smoke test. Sends a trivial prompt and logs the response.
    """
    client = GeminiClient()
    response = client.generate_text(prompt="Reply with OK")
    logger.info(f"Gemini smoke test response: {response}")
