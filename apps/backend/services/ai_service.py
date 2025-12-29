import os
import json
import time
import logging
from datetime import datetime
from typing import Dict

import google.generativeai as genai

from .db_service import log_ai_usage
from .db_reminders import insert_ai_reminders

logger = logging.getLogger(__name__)

# AI prompt template for medical visit summarization
MEDICAL_SUMMARY_PROMPT = """
You are a warm, friendly highly efficient Clinical Documentation Assistant.
Your task is to process the doctor-patient visit transcript and structure the information into a single, valid JSON object.

Context:
- **Today's Date and Time:** {current_datetime}
(Use this information to calculate and create forward-looking reminders based on the transcript's discussion, such as "Schedule follow-up in 6 months".)

Response Rules:
- Output ONLY the JSON object (no markdown, commentary, or reasoning).
- Keep the tone friendly, natural, and easy to understand — AVOID medical jargon or technical terms.
- Focus on clarity and empathy, as if explaining to a patient or caregiver.
- Use the following keys:
"summary": a short, plain-language recap of what was discussed during the visit including (if mentioned) chief complaint, cause, and the primary plan. The text must be written entirely in the **third person** (e.g., 'The patient presented with...', 'The doctor recommended...').
"action_items": List **every** specific directive the doctor asked the patient to do next. Do not personalize using you/your for example do not say 'Continue your blood-pressure check-up daily', Say 'Continue blood-pressure check-up daily'.
"questions_next_visit": Generate at least two simple, caring questions a patient might ask at their next appointment. Use 2-3 relevant questions from the following styles: routine, medication, chronic, or caregiver. Keep them short, supportive, and in plain language.
"key_diagnoses": List **all** main diagnoses, conditions, or primary concerns mentioned (if any).
"medications": List **all** medications mentioned (prescribed, existing, or discontinued).
"title": Generate a brief, descriptive title (3-5 words) for the visit based on the **type of visit** (Example Annual Checkup, Follow-up Visit, Lab Results Review). Do not use the chief complaint for title. If a title cannot be clearly determined from the transcript, return Doctor Office Visit.
"reminders": List **all** reminders and only those that are STRICTLY TIME-BASED (MUST contain a date, time, or specific duration like "in next month").
Use Today's Date and Time to calculate precise future dates when a timeframe is mentioned.

The reminder text **MUST** be a COMPLETE instruction, that answers:
- WHAT needs to be done (specific action)
- WHO/WHAT it involves (doctor name, medication name, appointment type)
- WHEN it should be done (exact date/time or clear timeframe)
- Example: 'Take sugar medication daily at 8 AM' or 'Schedule next check-up in December 2025'.
- Do not personalize like 'your check-up'
- Do not be vague like 'Visit again next week' or 'Visit again after one week', instead say 'Schedule follow-up appointment on November 20, 2025' (**include WHEN**).

Return in this format:
[{{
        "text": "Take Lisinopril 10mg daily at 8 AM",
        "type": "medication",
        "scheduled_date": "2025-11-04",
        "scheduled_time": "08:00",
        "recurrence": "daily"
}}, {{..}}]
The 'type' field can be one of these only: **medication**, **appointment**, or **task**.
The 'recurrence' field can be one of these only: **daily**, **weekly**, **fortnightly**, **monthly**, **annually**, or **once**. Use 'once' for all single-event reminders, and 'fortnightly' for every two weeks.
Extract the date, time, and recurrence details from the instruction to populate the corresponding 'scheduled_date' (YYYY-MM-DD), 'scheduled_time' (HH:MM), and 'recurrence' fields.
If the transcript does not contain details like date or time, the value for the field MUST be an empty string. For example, do not fill dates/times/recurrence on assumptions.

Transcript:
{transcript}
"""


async def generate_ai_summary(data: dict) -> Dict:
    visit_id = data.get('visit_id')
    logger.info(f"AI Service started for visit: {visit_id}")

    # Get required environment variables
    api_key = os.getenv("GEMINI_API_KEY")
    model_name = os.getenv("MODEL_NAME")
    input_cost_per_m = float(os.getenv("GEMINI_INPUT_COST_PER_M"))
    output_cost_per_m = float(os.getenv("GEMINI_OUTPUT_COST_PER_M"))

    if not api_key:
        raise RuntimeError("GEMINI_API_KEY not set")
    if not model_name:
        raise RuntimeError("MODEL_NAME not set")

    # Configure Gemini API
    genai.configure(api_key=api_key)
    model = genai.GenerativeModel(model_name)

    transcript = data["transcript"]
    current_datetime = datetime.now().strftime("%A, %B %d, %Y, %I:%M %p %Z")
    prompt = MEDICAL_SUMMARY_PROMPT.format(
        current_datetime=current_datetime,
        transcript=transcript
    )

    try:
        start_time = time.time()
        response = model.generate_content(prompt)
        latency = time.time() - start_time

        input_tokens = response.usage_metadata.prompt_token_count
        output_tokens = response.usage_metadata.candidates_token_count

        input_cost = (input_tokens / 1_000_000) * input_cost_per_m
        output_cost = (output_tokens / 1_000_000) * output_cost_per_m
        total_cost = input_cost + output_cost

        # Log AI usage
        await log_ai_usage({
            "visit_id": visit_id,
            "user_id": data.get("user_id"),
            "transcript_id": data.get("transcript_id"),
            "input_tokens": input_tokens,
            "output_tokens": output_tokens,
            "total_cost": total_cost,
        })

        # Parse JSON response
        text_output = response.text.strip()
        start_json = text_output.find("{")
        end_json = text_output.rfind("}")
        json_string = text_output[start_json:end_json + 1]
        json_output = json.loads(json_string)

        logger.info(f"Summary generated in {latency:.2f}s, cost: ${total_cost:.6f}")
        # Build result
        result = {
            "summary": json_output.get("summary", f"AI Processing error:{transcript}"),
            "action_items": json_output.get("action_items", []),
            "questions_next_visit": json_output.get("questions_next_visit", []),
            "key_diagnoses": json_output.get("key_diagnoses", []),
            "medications": json_output.get("medications", []),
            "reminders": json_output.get("reminders", []),
            "title": json_output.get("title", "Doctor Office Visit"),
        }

        # Insert reminders if we have user and visit IDs
        user_id = data.get("user_id")
        if user_id and visit_id:
            inserted_reminders = await insert_ai_reminders(
                ai_summary_result=result,
                user_id=user_id,
                visit_id=visit_id,
            )
            logger.info(f"Inserted {len(inserted_reminders)} reminders into database")

        return result
        
    except json.JSONDecodeError as e:
        logger.error(f"JSON parsing failed: {str(e)}")
        return {
            "summary": f"Error processing visit summary. Please contact support:{transcript}",
            "action_items": ["Review visit recording"],
            "questions_next_visit": ["Could you clarify the diagnosis?"],
            "key_diagnoses": [],
            "medications": [],
            "reminders": [],
            "title": ""
        }
    except Exception as e:
        logger.error(f"AI Service Failed: {str(e)}")
        raise Exception(f"AI service failed: {str(e)}")
