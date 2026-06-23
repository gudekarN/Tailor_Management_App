from pydantic import BaseModel, field_validator
from typing import Optional, List
from datetime import date, datetime


# ── OrderItem sub-schemas ─────────────────────────────────────────────────────

class OrderItemCreate(BaseModel):
    item_name: str
    design_image_url: Optional[str] = None
    price: float


class OrderItemResponse(BaseModel):
    id: int
    order_id: int
    item_name: str
    design_image_url: Optional[str] = None
    price: float
    assigned_to: Optional[int] = None
    assignee_name: Optional[str] = None
    status: str
    completed_at: Optional[datetime] = None

    class Config:
        from_attributes = True


# ── OrderSampleImage sub-schemas ─────────────────────────────────────────────

class OrderSampleImageCreate(BaseModel):
    image_url: str


class OrderSampleImageResponse(BaseModel):
    id: int
    order_id: int
    image_url: str

    class Config:
        from_attributes = True


# ── Order Create / Update ─────────────────────────────────────────────────────

class OrderCreate(BaseModel):
    customer_id: int
    design_extra_charge: float = 0.0
    is_urgent: bool = False
    urgent_cost: float = 0.0
    total: float
    advance_paid: float = 0.0
    delivery_date: date
    items: List[OrderItemCreate]
    sample_images: List[OrderSampleImageCreate] = []

    @field_validator("items")
    @classmethod
    def items_not_empty(cls, v):
        if not v:
            raise ValueError("Order must have at least one item")
        return v


class OrderUpdate(BaseModel):
    design_extra_charge: Optional[float] = None
    is_urgent: Optional[bool] = None
    urgent_cost: Optional[float] = None
    total: Optional[float] = None
    advance_paid: Optional[float] = None
    remaining: Optional[float] = None
    delivery_date: Optional[date] = None
    status: Optional[str] = None


# ── Order Responses ───────────────────────────────────────────────────────────

class OrderListItem(BaseModel):
    """Lightweight response used in list endpoints."""
    id: int
    receipt_no: str
    customer_id: int
    customer_name: Optional[str] = None
    design_extra_charge: float
    is_urgent: bool
    urgent_cost: float
    total: float
    advance_paid: float
    remaining: float
    delivery_date: date
    generated_by: Optional[int] = None
    status: str
    created_at: datetime

    class Config:
        from_attributes = True


class BlouseMeasurementBrief(BaseModel):
    back_length: Optional[float] = None
    full_shoulder: Optional[float] = None
    shoulder_strap: Optional[float] = None
    back_neck_depth: Optional[float] = None
    front_neck_depth: Optional[float] = None
    shoulder_to_apex: Optional[float] = None
    front_length: Optional[float] = None
    chest: Optional[float] = None
    waist: Optional[float] = None
    sleeve_length: Optional[float] = None
    arm_round: Optional[float] = None
    sleeve_round: Optional[float] = None
    arm_hole: Optional[float] = None

    class Config:
        from_attributes = True


class DressMeasurementBrief(BaseModel):
    upper_back_length: Optional[float] = None
    upper_full_shoulder: Optional[float] = None
    upper_shoulder_strap: Optional[float] = None
    upper_back_neck_depth: Optional[float] = None
    upper_front_neck_depth: Optional[float] = None
    upper_shoulder_to_apex: Optional[float] = None
    upper_front_length: Optional[float] = None
    upper_chest: Optional[float] = None
    upper_waist: Optional[float] = None
    upper_sleeve_length: Optional[float] = None
    upper_arm_round: Optional[float] = None
    upper_sleeve_round: Optional[float] = None
    upper_arm_hole: Optional[float] = None
    upper_seat: Optional[float] = None
    lower_height: Optional[float] = None
    lower_waist: Optional[float] = None
    lower_seat: Optional[float] = None
    lower_bottom: Optional[float] = None
    dupatta: bool = False

    class Config:
        from_attributes = True


class CustomerBrief(BaseModel):
    id: int
    name: str
    phone: str
    blouse_measurement: Optional[BlouseMeasurementBrief] = None
    dress_measurement: Optional[DressMeasurementBrief] = None

    class Config:
        from_attributes = True


class OrderDetailResponse(BaseModel):
    """Full order detail including customer info, measurements, items, images."""
    id: int
    receipt_no: str
    customer: CustomerBrief
    design_extra_charge: float
    is_urgent: bool
    urgent_cost: float
    total: float
    advance_paid: float
    remaining: float
    delivery_date: date
    generated_by: Optional[int] = None
    status: str
    created_at: datetime
    items: List[OrderItemResponse] = []
    sample_images: List[OrderSampleImageResponse] = []

    class Config:
        from_attributes = True
