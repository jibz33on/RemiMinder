import os
import json
import time
import logging
from typing import Dict, Optional, Any

from domain.reminders.repo import get_prompt_text_by_name, get_templates_by_type
from domain.ports.ai import generate_reminder_message as generate_reminder_message_via_port

logger = logging.getLogger(__name__)

async def build_reminder_prompt(
    prompt_category: str,
    reminder_type: str, 
    reminder_title: str, 
) -> str:
    """
    Constructs the full few-shot prompt for a reminder message.
    Base instructions come from the prompt_bank.
    Few-Shot Examples come from the reminder_templates table.
    """
    
    # 1. Get Base Prompt Text
    try:
        base_prompt_text = await get_prompt_text_by_name(prompt_category)
        print("\n BASE PROMPT TEXT", base_prompt_text)
    except Exception as e:
        logger.error(f"Failed to fetch prompt from database: {str(e)}")
        base_prompt_text = None
    
    if not base_prompt_text:
        logger.warning("Using fallback prompt text")
        base_prompt_text = "Generate a gentle, concise reminder based ONLY on the provided facts. Do not add new medical advice. 1 sentence only."
    try:
        templates = await get_templates_by_type(reminder_type)
        logger.info(f"Found {len(templates)} templates for type '{reminder_type}'")
    except Exception as e:
        logger.error(f"Failed to fetch templates: {str(e)}")
        templates = []

    # 3. Assemble the Final Prompt
    final_prompt = f"Task: {base_prompt_text}\n"
    final_prompt += "Your output must be plain-language and caring yet concise.\n"
    
    final_prompt += "\n---Generate for---\n"
    final_prompt += f"Reminder Type: {reminder_type}\n"
    final_prompt += f"Title: {reminder_title}\n"
    
    # 4. Add Few-Shot Block using Templates
    if templates:
        final_prompt += "\n--- Example Reference ---\n"
        for t in templates:
            tone = t.get('tone_persona', 'General')
            template_content = t['template_content'].strip().replace('\n', ' ')
            final_prompt += f"\nTone/Persona: {tone}\n"
            final_prompt += f"Example Message: {template_content}\n"
    else:
        logger.warning("No templates found, generating without examples")
        
    final_prompt += "\n--- Final Output Instruction ---\n"
    final_prompt += "Using the context above, generate the final reminder message.\n"
    final_prompt += "Output ONLY the final message text, no explanations or prefixes"
    print("\n FINAL PROMPT: ", final_prompt)
    return final_prompt


async def generate_reminder_message(
    reminder_type: str,
    title: str,
    context_data: Optional[Dict] = None,
    prompt_category_override: Optional[str] = None
) -> str:
    """
    Generates a personalized, warm reminder message using the few-shot prompt system.
    Returns the AI-generated message or a fallback message string.
    """
    print("\n ENTERED GENERATE REMINDER MESSAGE")
    if not context_data:
        context_data = {}

    # Determine prompt category
    if prompt_category_override:
        prompt_category = prompt_category_override
    elif reminder_type == "appointment":
        prompt_category = 'Appointment Reminder'
    elif 'caregiver' in reminder_type:
        prompt_category = 'Caregiver Summary'
    elif reminder_type == 'encouragement':
        prompt_category = 'Adherence Nudge'
    else:
        prompt_category = 'Reminder Message'

    print("PROMPT_CATEGORY:", prompt_category)
    
    try:
        # 3. Build Few-Shot Prompt
        prompt = await build_reminder_prompt(
            prompt_category=prompt_category,
            reminder_type=reminder_type,
            reminder_title=title,
        )
        
        logger.debug(f"Generated prompt (first 200 chars): {prompt[:200]}...")

        start_time = time.time()
        ai_message = await generate_reminder_message_via_port(prompt, title)
        latency = time.time() - start_time

        logger.info("Generated message for '%s' | Latency: %.2fs", title, latency)

        return ai_message
        
    except Exception as e:
        logger.error(f"Failed to generate reminder message: {str(e)}", exc_info=True)
        return f"Reminder: {title}"


async def generate_caregiver_alert_message(
    alert_type: str,
    reminder_title: str,
    reminder_type: str,
    patient_name: str
) -> str:
    """
    Generate a message for caregiver alerts.
    """
    alert_action = "has skipped" if alert_type == "skipped" else "has snoozed multiple times"
    full_title_for_ai = (
        f"Patient {patient_name} {alert_action} their {reminder_type} reminder: {reminder_title}."
    )
    
    alert_message = await generate_reminder_message(
        reminder_type='caregiver_alert', 
        title=full_title_for_ai,
        prompt_category_override='Caregiver Alert'
    )
    
    return alert_message
