from pydantic import BaseModel
from typing import Optional

class LoginRequest(BaseModel):
    phone: str
    pin: str

class TokenResponse(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str = "bearer"

class RefreshRequest(BaseModel):
    refresh_token: str

class UserResponse(BaseModel):
    id: int
    name: str
    phone: str
    role: str
    is_active: bool

    class Config:
        orm_mode = True
        from_attributes = True
