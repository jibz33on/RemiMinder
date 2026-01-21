"""
Medical Summary Actions V2 Prompt (re-export).

This module provides the V2 prompt builder entrypoint expected by the AI pipeline.
"""

from utils.prompts.medical_summary_v2 import build_medical_summary_prompt_v2

__all__ = ["build_medical_summary_prompt_v2"]
