import os
import time
import google.generativeai as genai

from domain.ports.logging import get_logger

logger = get_logger()


async def generate_reminder_message_from_prompt(prompt: str, title: str) -> str:
    """
    Provider-backed reminder message generation using Gemini.
    """
    try:
        INPUT_COST_PER_M = float(os.getenv("GEMINI_INPUT_COST_PER_M", 0.30))
        OUTPUT_COST_PER_M = float(os.getenv("GEMINI_OUTPUT_COST_PER_M", 2.50))
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            return f"Error: GEMINI_API_KEY missing. Cannot generate message for '{title}'."

        genai.configure(api_key=api_key)
        model_name = os.getenv("MODEL_NAME", "gemini-2.5-flash-lite")
        model = genai.GenerativeModel(
            model_name,
            generation_config={
                "temperature": 0.5,
                "top_p": 0.9,
                "top_k": 40,
            },
        )

        start_time = time.time()
        response = model.generate_content(prompt)
        latency = time.time() - start_time

        if not response.text:
            logger.error("Gemini returned empty response")
            return f"Reminder: {title}"

        ai_message = response.text.strip()
        input_tokens = response.usage_metadata.prompt_token_count
        output_tokens = response.usage_metadata.candidates_token_count

        input_cost = (input_tokens / 1_000_000) * INPUT_COST_PER_M
        output_cost = (output_tokens / 1_000_000) * OUTPUT_COST_PER_M
        total_cost = input_cost + output_cost

        logger.info(
            "Generated message for '%s' | Tokens: %s→%s | Cost: $%.6f | Latency: %.2fs",
            title,
            input_tokens,
            output_tokens,
            total_cost,
            latency,
        )

        return ai_message

    except Exception as e:
        logger.exception(f"Failed to generate reminder message: {e}")
        return f"Reminder: {title}"
