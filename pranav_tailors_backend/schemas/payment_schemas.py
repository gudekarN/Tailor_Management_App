from pydantic import BaseModel
from typing import Optional
from datetime import date

class PaymentCreate(BaseModel):
    employee_id: int
    amount: float
    date: Optional[date] = None
    notes: Optional[str] = None

class PaymentResponse(BaseModel):
    id: int
    employee_id: int
    amount: float
    date: date
    given_by: Optional[int] = None
    notes: Optional[str] = None

    class Config:
        from_attributes = True
