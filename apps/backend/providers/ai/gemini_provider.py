"""
Gemini provider adapter.

Keeps AI integrations behind a stable provider interface so the rest of the app
does not depend on vendor-specific modules.
"""

from providers.ai.vertex_gemini_service import generate_visit_summary

__all__ = ["generate_visit_summary"]
