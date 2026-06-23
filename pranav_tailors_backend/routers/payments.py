from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List
from datetime import date

from database.database import get_db
from models.user import User
from models.payment import EmployeePayment, Expense, ExpenseType
from core.dependencies import require_manager, require_any
from schemas.payment_schemas import PaymentCreate, PaymentResponse

router = APIRouter()

@router.post("", response_model=PaymentResponse)
async def create_payment(
    req: PaymentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    p_date = req.date or date.today()
    payment = EmployeePayment(
        employee_id=req.employee_id,
        amount=req.amount,
        date=p_date,
        given_by=current_user.id,
        notes=req.notes
    )
    db.add(payment)
    await db.flush()
    
    expense = Expense(
        type=ExpenseType.employee_payment,
        amount=req.amount,
        date=p_date,
        reference_id=payment.id,
        notes=f"Employee Payment: {req.notes or ''}"
    )
    db.add(expense)
    await db.commit()
    await db.refresh(payment)
    return payment

@router.get("/employee/{id}", response_model=List[PaymentResponse])
async def get_employee_payments(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any)
):
    stmt = select(EmployeePayment).where(EmployeePayment.employee_id == id).order_by(EmployeePayment.date.desc())
    res = await db.execute(stmt)
    return res.scalars().all()
