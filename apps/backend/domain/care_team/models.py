from pydantic import BaseModel, EmailStr


class CareTeamInviteRequest(BaseModel):
    email: EmailStr
    role: str
    permission: str


class CareTeamAcceptRequest(BaseModel):
    token: str


class CareTeamPermissionUpdateRequest(BaseModel):
    permission: str
