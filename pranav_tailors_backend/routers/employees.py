import sys
import os
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List

from database.database import get_db
from models.user import User, UserRole
from models.order import OrderItem, OrderItemStatus
from models.payment import EmployeePayment
from core.dependencies import require_manager, require_any
from schemas.employee_schemas import (
    EmployeeCreate, EmployeeUpdate, EmployeeResponse, EmployeeListResponse,
    EarningsBalanceResponse
)
from schemas.work_queue_schemas import WorkQueueItemResponse
from utils.password_utils import hash_pin

router = APIRouter()

@router.post("", response_model=EmployeeResponse)
async def create_employee(
    req: EmployeeCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(User).where(User.phone == req.phone)
    res = await db.execute(stmt)
    if res.scalar_one_or_none():
        raise HTTPException(status_code=400, detail="Phone already exists")
    
    hashed_pin = hash_pin(req.pin)
    user = User(
        name=req.name,
        phone=req.phone,
        role=UserRole(req.role),
        pin_hash=hashed_pin
    )
    db.add(user)
    await db.commit()
    await db.refresh(user)
    return user

@router.get("", response_model=List[EmployeeListResponse])
async def list_employees(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(User)
    res = await db.execute(stmt)
    users = res.scalars().all()
    
    result = []
    for u in users:
        # active work count
        work_stmt = select(OrderItem).where(
            OrderItem.assigned_to == u.id,
            OrderItem.status == OrderItemStatus.in_progress
        )
        work_res = await db.execute(work_stmt)
        active_work_count = len(work_res.scalars().all())
        
        # earnings
        earned_stmt = select(OrderItem.price).where(
            OrderItem.assigned_to == u.id,
            OrderItem.status == OrderItemStatus.complete
        )
        earned_res = await db.execute(earned_stmt)
        total_earned = sum(earned_res.scalars().all())
        
        paid_stmt = select(EmployeePayment.amount).where(EmployeePayment.employee_id == u.id)
        paid_res = await db.execute(paid_stmt)
        total_paid = sum(paid_res.scalars().all())
        
        balance = total_earned - total_paid
        
        result.append(EmployeeListResponse(
            id=u.id, name=u.name, phone=u.phone, role=u.role.value, is_active=u.is_active,
            active_work_count=active_work_count, earnings_balance=balance
        ))
    return result

@router.get("/{id}", response_model=EmployeeResponse)
async def get_employee(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(User).where(User.id == id)
    res = await db.execute(stmt)
    user = res.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="Employee not found")
    return user

@router.put("/{id}", response_model=EmployeeResponse)
async def update_employee(
    id: int,
    req: EmployeeUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(User).where(User.id == id)
    res = await db.execute(stmt)
    user = res.scalar_one_or_none()
    if not user:
        raise HTTPException(status_code=404, detail="Employee not found")
    
    update_data = req.model_dump(exclude_unset=True)
    for k, v in update_data.items():
        if k == 'role':
            v = UserRole(v)
        setattr(user, k, v)
        
    await db.commit()
    await db.refresh(user)
    return user

@router.get("/{id}/work-summary", response_model=List[WorkQueueItemResponse])
async def get_work_summary(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    from sqlalchemy.orm import selectinload
    from models.order import Order
    stmt = select(OrderItem).options(
        selectinload(OrderItem.order).selectinload(Order.customer),
        selectinload(OrderItem.assignee)
    ).where(OrderItem.assigned_to == id)
    res = await db.execute(stmt)
    items = res.scalars().all()
    
    return [
        {
            "id": i.id,
            "order_id": i.order_id,
            "receipt_no": i.order.receipt_no,
            "customer_name": i.order.customer.name if i.order.customer else "",
            "delivery_date": i.order.delivery_date,
            "is_urgent": i.order.is_urgent,
            "item_name": i.item_name,
            "design_image_url": i.design_image_url,
            "price": i.price,
            "status": i.status,
            "assigned_to": i.assigned_to,
            "assignee_name": i.assignee.name if i.assignee else None,
            "completed_at": i.completed_at
        } for i in items
    ]

@router.get("/{id}/earnings-balance", response_model=EarningsBalanceResponse)
async def get_earnings_balance(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    earned_stmt = select(OrderItem.price).where(
        OrderItem.assigned_to == id,
        OrderItem.status == OrderItemStatus.complete
    )
    earned_res = await db.execute(earned_stmt)
    total_earned = sum(earned_res.scalars().all())
    
    paid_stmt = select(EmployeePayment.amount).where(EmployeePayment.employee_id == id)
    paid_res = await db.execute(paid_stmt)
    total_paid = sum(paid_res.scalars().all())
    
    return EarningsBalanceResponse(
        total_earned=total_earned,
        total_paid=total_paid,
        balance_due=total_earned - total_paid
    )
