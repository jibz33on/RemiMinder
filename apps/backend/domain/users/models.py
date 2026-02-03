from pydantic import BaseModel
from typing import Optional


class UserResponse(BaseModel):
    id: str
    email: str
    full_name: Optional[str] = None
    display_name: str
    role: str


class CreateUserRequest(BaseModel):
    auth_uid: str
    email: str
    role: str
    full_name: Optional[str] = None


class UpdateRoleRequest(BaseModel):
    role: str


class UserMeResponse(BaseModel):
    full_name: Optional[str] = None
    email: str
    phone: Optional[str] = None
    role: Optional[str] = None  # "caregiver" | None when unknown


class BootstrapRequest(BaseModel):
    full_name: Optional[str] = None


class LanguagePreferencesResponse(BaseModel):
    app_language: str
    visit_language: str


class UpdateLanguagePreferencesRequest(BaseModel):
    app_language: str
    visit_language: str


class UpdatePhoneRequest(BaseModel):
    phone: Optional[str] = None


class UpdatePhoneResponse(BaseModel):
    phone: Optional[str] = None
