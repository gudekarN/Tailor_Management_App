from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class EmployeeCreate(BaseModel):
    name: str
    phone: str
    role: str
    pin: str

class EmployeeUpdate(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    role: Optional[str] = None
    is_active: Optional[bool] = None

class EmployeeResponse(BaseModel):
    id: int
    name: str
    phone: str
    role: str
    is_active: bool

    class Config:
        from_attributes = True

class EmployeeListResponse(EmployeeResponse):
    active_work_count: int
    earnings_balance: float

class EarningsBalanceResponse(BaseModel):
    total_earned: float
    total_paid: float
    balance_due: float
