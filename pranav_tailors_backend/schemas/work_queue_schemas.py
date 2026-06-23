from pydantic import BaseModel
from typing import Optional, List
from datetime import date, datetime


class AssignRequest(BaseModel):
    user_id: int


class SetNewDateRequest(BaseModel):
    delivery_date: date


class WorkQueueItemResponse(BaseModel):
    """Single order item with full context for the work queue view."""
    id: int
    order_id: int
    receipt_no: str
    customer_name: str
    delivery_date: date
    is_urgent: bool
    item_name: str
    design_image_url: Optional[str] = None
    price: float
    status: str
    assigned_to: Optional[int] = None
    assignee_name: Optional[str] = None
    completed_at: Optional[datetime] = None

    class Config:
        from_attributes = True


class CompletedOrderGroup(BaseModel):
    """Order with completion summary, grouping complete and incomplete items."""
    order_id: int
    receipt_no: str
    customer_name: str
    delivery_date: date
    is_fully_complete: bool
    total_items: int
    completed_items: int
    items: List[WorkQueueItemResponse]
