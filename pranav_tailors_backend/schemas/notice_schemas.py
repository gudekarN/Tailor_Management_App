from pydantic import BaseModel
from datetime import datetime

class NoticeCreate(BaseModel):
    title: str
    message: str

class NoticeResponse(BaseModel):
    id: int
    title: str
    message: str
    created_by: int
    created_at: datetime
    is_active: bool

    class Config:
        from_attributes = True
