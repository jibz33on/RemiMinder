import importlib
import os

from domain.ports import ai as ai_port
from domain.ports import auth as auth_port
from domain.ports import cache as cache_port
from domain.ports import db as db_port
from domain.ports import jobs as jobs_port
from domain.ports import notifications as notifications_port
from domain.ports import stt as stt_port
from domain.ports import storage as storage_port
from domain.ports import vision as vision_port

from infra.cache import cache_service
from infra.db.cloud_sql_engine import get_cloud_sql_engine
from infra.jobs.jobs_service import create_job


class CacheAdapter(cache_port.CacheProvider):
    def get(self, key: str):
        return cache_service.get(key)

    def set(self, key: str, value, ttl_seconds: int) -> None:
        cache_service.set(key, value, ttl_seconds)

    def invalidate(self, key: str) -> None:
        cache_service.invalidate(key)

    def invalidate_prefix(self, prefix: str) -> None:
        cache_service.invalidate_prefix(prefix)

    def get_or_set(self, key: str, ttl_seconds: int, loader):
        return cache_service.get_or_set(key, ttl_seconds, loader)


def _load_attr(spec: str):
    module_path, attr = spec.split(":")
    module = importlib.import_module(module_path)
    return getattr(module, attr)


def _load_provider(spec_env: str):
    spec = os.getenv(spec_env)
    if not spec:
        raise RuntimeError(f"Missing provider config: {spec_env}")
    return _load_attr(spec)


def wire_infra_ports() -> None:
    db_port.set_db_engine_provider(get_cloud_sql_engine)
    cache_port.set_cache_provider(CacheAdapter())
    jobs_port.set_job_creator(create_job)
    ai_port.set_visit_summary_provider(_load_provider("AI_VISIT_SUMMARY_PROVIDER"))
    ai_port.set_model_name_provider(lambda: _load_provider("AI_MODEL_NAME_PROVIDER"))
    ai_port.set_reminder_message_provider(_load_provider("AI_REMINDER_MESSAGE_PROVIDER"))
    stt_port.set_stt_provider(_load_provider("STT_PROVIDER"))
    storage_port.set_storage_providers(
        _load_provider("STORAGE_UPLOAD_AUDIO_PROVIDER"),
        _load_provider("STORAGE_UPLOAD_IMAGE_PROVIDER"),
    )
    storage_port.set_image_reference_builder(_load_provider("STORAGE_IMAGE_REFERENCE_PROVIDER"))
    vision_port.set_ocr_provider(_load_provider("VISION_OCR_PROVIDER"))
    vision_port.set_ocr_provider_name(_load_provider("VISION_OCR_PROVIDER_NAME"))
    notifications_port.set_caregiver_alert_email_sender(
        _load_provider("NOTIFICATIONS_CAREGIVER_EMAIL_PROVIDER")
    )
    auth_port.get_current_user_jwt = _load_provider("AUTH_GET_CURRENT_USER_JWT")
    auth_port.get_current_user = _load_provider("AUTH_GET_CURRENT_USER")


def configure_auth_overrides(app) -> None:
    """
    Register FastAPI dependency overrides for auth.
    """
    from domain import auth as domain_auth

    app.dependency_overrides[domain_auth.get_current_user_jwt] = _load_provider(
        "AUTH_GET_CURRENT_USER_JWT"
    )
    app.dependency_overrides[domain_auth.get_current_user] = _load_provider(
        "AUTH_GET_CURRENT_USER"
    )