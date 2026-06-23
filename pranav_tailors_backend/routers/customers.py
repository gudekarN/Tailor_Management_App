from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy import or_
from typing import List, Optional

from database.database import get_db
from models.user import User
from models.customer import Customer
from models.measurements import BlouseMeasurement, DressMeasurement
from core.dependencies import require_any
from schemas.customer_schemas import (
    CustomerCreate, CustomerUpdate, CustomerResponse, CustomerDetailResponse,
    BlouseMeasurementCreate, DressMeasurementCreate
)

router = APIRouter()

@router.post("", response_model=CustomerResponse)
async def create_customer(
    req: CustomerCreate, 
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(Customer).where(Customer.phone == req.phone)
    result = await db.execute(stmt)
    if result.scalar_one_or_none():
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Phone already registered")

    customer = Customer(
        **req.model_dump(),
        created_by=current_user.id
    )
    db.add(customer)
    await db.commit()
    await db.refresh(customer)
    return customer

@router.get("", response_model=List[CustomerResponse])
async def get_customers(
    search: Optional[str] = None,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(Customer)
    if search:
        stmt = stmt.where(
            or_(
                Customer.name.ilike(f"%{search}%"),
                Customer.phone.ilike(f"%{search}%")
            )
        )
    result = await db.execute(stmt)
    customers = result.scalars().all()
    return customers

@router.get("/{id}", response_model=CustomerDetailResponse)
async def get_customer(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(Customer).options(
        selectinload(Customer.blouse_measurement),
        selectinload(Customer.dress_measurement)
    ).where(Customer.id == id)
    result = await db.execute(stmt)
    customer = result.scalar_one_or_none()
    
    if not customer:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
        
    return customer

@router.put("/{id}", response_model=CustomerResponse)
async def update_customer(
    id: int,
    req: CustomerUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(Customer).where(Customer.id == id)
    result = await db.execute(stmt)
    customer = result.scalar_one_or_none()
    
    if not customer:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")

    update_data = req.model_dump(exclude_unset=True)
    for key, value in update_data.items():
        setattr(customer, key, value)
        
    await db.commit()
    await db.refresh(customer)
    return customer

@router.post("/{id}/blouse-measurement", response_model=BlouseMeasurementCreate)
async def upsert_blouse_measurement(
    id: int,
    req: BlouseMeasurementCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(BlouseMeasurement).where(BlouseMeasurement.customer_id == id)
    result = await db.execute(stmt)
    measurement = result.scalar_one_or_none()
    
    if measurement:
        update_data = req.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(measurement, key, value)
    else:
        c_stmt = select(Customer).where(Customer.id == id)
        c_res = await db.execute(c_stmt)
        if not c_res.scalar_one_or_none():
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
            
        measurement = BlouseMeasurement(**req.model_dump(), customer_id=id)
        db.add(measurement)

    await db.commit()
    await db.refresh(measurement)
    return measurement

@router.post("/{id}/dress-measurement", response_model=DressMeasurementCreate)
async def upsert_dress_measurement(
    id: int,
    req: DressMeasurementCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(DressMeasurement).where(DressMeasurement.customer_id == id)
    result = await db.execute(stmt)
    measurement = result.scalar_one_or_none()
    
    if measurement:
        update_data = req.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(measurement, key, value)
    else:
        c_stmt = select(Customer).where(Customer.id == id)
        c_res = await db.execute(c_stmt)
        if not c_res.scalar_one_or_none():
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Customer not found")
            
        measurement = DressMeasurement(**req.model_dump(), customer_id=id)
        db.add(measurement)

    await db.commit()
    await db.refresh(measurement)
    return measurement
