from pydantic import BaseModel
from typing import Optional
from datetime import date

class MeasurementBase(BaseModel):
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

class BlouseMeasurementCreate(MeasurementBase):
    pass

class BlouseMeasurementResponse(MeasurementBase):
    id: int
    customer_id: int

    class Config:
        orm_mode = True
        from_attributes = True

class DressMeasurementCreate(BaseModel):
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

class DressMeasurementResponse(DressMeasurementCreate):
    id: int
    customer_id: int

    class Config:
        orm_mode = True
        from_attributes = True

class CustomerCreate(BaseModel):
    name: str
    phone: str
    date_of_birth: Optional[date] = None
    address: Optional[str] = None

class CustomerUpdate(BaseModel):
    name: Optional[str] = None
    phone: Optional[str] = None
    date_of_birth: Optional[date] = None
    address: Optional[str] = None

class CustomerResponse(BaseModel):
    id: int
    name: str
    phone: str
    date_of_birth: Optional[date] = None
    age: Optional[int] = None
    address: Optional[str] = None
    created_at: date
    created_by: Optional[int] = None

    class Config:
        orm_mode = True
        from_attributes = True

class CustomerDetailResponse(CustomerResponse):
    blouse_measurement: Optional[BlouseMeasurementResponse] = None
    dress_measurement: Optional[DressMeasurementResponse] = None
