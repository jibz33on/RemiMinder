"""
Vertex Gemini Service - Pure LLM adapter for medical visit summaries.

This service provides a clean interface to Vertex AI Gemini models without
any database operations or business logic. It focuses solely on LLM inference.
"""

import logging
import os
from datetime import datetime

from google.cloud import aiplatform
from vertexai.generative_models import GenerativeModel  # type: ignore

# Constants
GEMINI_MODEL = "gemini-1.5-flash"
logger = logging.getLogger(__name__)


def build_plain_text_summary_prompt(transcript: str) -> str:
    """
    Build a simple prompt for generating plain-text medical visit summaries.
    """
    current_datetime = datetime.now().strftime("%A, %B %d, %Y, %I:%M %p")

    return f"""You are a helpful medical assistant. Please provide a clear, concise summary of this doctor-patient conversation.

Current date and time: {current_datetime}

Please write a patient-friendly summary that covers:
- What the patient discussed with the doctor
- Any diagnoses or concerns mentioned
- Medications discussed (if any)
- Next steps or follow-up instructions

Keep the summary clear, empathetic, and easy to understand. Write in plain language without medical jargon.

Transcript:
{transcript}

Summary:"""


async def generate_visit_summary(raw_text: str) -> str:
    """
    Calls Vertex Gemini and returns a plain-text medical summary.

    Args:
        raw_text: The raw transcript text to summarize

    Returns:
        Plain text summary from Gemini

    Raises:
        Exception: If Gemini API call fails
    """
    try:
        # Get configuration from environment
        project_id = os.getenv("GCP_PROJECT")
        region = os.getenv("GCP_REGION")

        if not project_id or not region:
            raise ValueError("GCP_PROJECT and GCP_REGION environment variables must be set")

        logger.info(f"Initializing Vertex AI with project: {project_id}, region: {region}")

        # Initialize Vertex AI
        aiplatform.init(project=project_id, location=region)

        # Get the model
        model = GenerativeModel(GEMINI_MODEL)

        # Build the prompt
        prompt = build_plain_text_summary_prompt(raw_text)

        logger.info(f"Sending prompt to Gemini (length: {len(prompt)} chars)")

        # Generate response
        response = model.generate_content(prompt)

        # Extract and clean the text
        summary_text = response.text.strip()

        logger.info(f"Generated summary (length: {len(summary_text)} chars)")

        return summary_text

    except Exception as e:
        logger.error(f"Gemini API call failed: {str(e)}")
        raise
