from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class DesignResponse(BaseModel):
    id: int
    type: str
    image_url: str
    uploaded_by: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True
