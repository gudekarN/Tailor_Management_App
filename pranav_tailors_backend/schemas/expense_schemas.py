from pydantic import BaseModel
from typing import Optional, List
from datetime import date

class ExpenseResponse(BaseModel):
    id: int
    type: str
    amount: float
    date: date
    reference_id: Optional[int] = None
    notes: Optional[str] = None

    class Config:
        from_attributes = True

class ExpenseSummaryResponse(BaseModel):
    total_stitch_bills_this_month: float
    total_employee_payments_this_month: float
    combined_expenses_this_month: float
    shop_earnings_this_month: float
    net_balance_this_month: float

class MonthData(BaseModel):
    month: str # e.g., '2026-06'
    stitch_bill_total: float
    employee_payment_total: float

class ChartDataResponse(BaseModel):
    data: List[MonthData]
