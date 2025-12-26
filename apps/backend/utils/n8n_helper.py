import httpx
import os
import logging
import datetime
from typing import Any, Dict, Optional

logger = logging.getLogger(__name__)

async def trigger_n8n_event(event_name: str, payload: Dict[str, Any]) -> bool:
    """
    Triggers an n8n workflow via a webhook URL.
    
    The webhook URL should be configured in the N8N_WEBHOOK_URL environment variable.
    """
    webhook_url = os.getenv("N8N_WEBHOOK_URL")
    if not webhook_url:
        logger.warning("N8N_WEBHOOK_URL not configured. Skipping n8n event trigger.")
        return False
    
    try:
        async with httpx.AsyncClient() as client:
            response = await client.post(
                webhook_url,
                json={
                    "event": event_name,
                    "data": payload
                },
                timeout=10.0
            )
            response.raise_for_status()
            logger.info(f"Successfully triggered n8n event: {event_name}")
            return True
    except httpx.HTTPStatusError as e:
        logger.error(f"Failed to trigger n8n event '{event_name}': {e.response.status_code} - {e.response.text}")
        return False
    except Exception as e:
        logger.error(f"Unexpected error triggering n8n event '{event_name}': {str(e)}")
        return False


async def send_to_extraction_agent(ai_summary_data: Dict[str, Any]) -> bool:
    """
    Send AI summary data to the N8N extraction agent workflow.

    Expected payload format:
    {
        "transcript": "full conversation text",
        "summary": "AI generated summary",
        "action_items": ["item1", "item2"],
        "medications": ["med1", "med2"],
        "patient_id": "patient123",
        "visit_id": "visit456"
    }
    """
    return await trigger_n8n_event("extraction_agent", {
        "ai_summary": ai_summary_data,
        "timestamp": str(datetime.now()),
        "source": "mobile_app"
    })
