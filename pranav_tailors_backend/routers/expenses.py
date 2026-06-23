from fastapi import APIRouter, Depends, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import List, Optional
from datetime import date, timedelta
from collections import defaultdict

from database.database import get_db
from models.user import User
from models.payment import Expense, ExpenseType
from models.order import Order
from core.dependencies import require_manager
from schemas.expense_schemas import ExpenseResponse, ExpenseSummaryResponse, ChartDataResponse, MonthData

router = APIRouter()

@router.get("/summary", response_model=ExpenseSummaryResponse)
async def get_summary(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    today = date.today()
    start_of_month = today.replace(day=1)
    
    stmt = select(Expense).where(Expense.date >= start_of_month)
    res = await db.execute(stmt)
    expenses = res.scalars().all()
    
    stitch_total = sum(e.amount for e in expenses if e.type == ExpenseType.stitch_bill)
    emp_total = sum(e.amount for e in expenses if e.type == ExpenseType.employee_payment)
    
    o_stmt = select(Order.total).where(Order.created_at >= start_of_month)
    o_res = await db.execute(o_stmt)
    shop_earnings = sum(o_res.scalars().all())
    
    combined = stitch_total + emp_total
    return ExpenseSummaryResponse(
        total_stitch_bills_this_month=stitch_total,
        total_employee_payments_this_month=emp_total,
        combined_expenses_this_month=combined,
        shop_earnings_this_month=shop_earnings,
        net_balance_this_month=shop_earnings - combined
    )

@router.get("/chart-data", response_model=ChartDataResponse)
async def get_chart_data(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    today = date.today()
    start_date = today.replace(day=1) - timedelta(days=150) # Roughly 5-6 months ago
    start_date = start_date.replace(day=1)
    
    stmt = select(Expense).where(Expense.date >= start_date)
    res = await db.execute(stmt)
    expenses = res.scalars().all()
    
    data_dict = defaultdict(lambda: {'stitch_bill': 0.0, 'employee_payment': 0.0})
    for e in expenses:
        month_str = e.date.strftime("%Y-%m")
        if e.type == ExpenseType.stitch_bill:
            data_dict[month_str]['stitch_bill'] += e.amount
        else:
            data_dict[month_str]['employee_payment'] += e.amount
            
    # Sort months
    sorted_months = sorted(data_dict.keys())[-6:] # Last 6 months
    
    chart_data = []
    for m in sorted_months:
        chart_data.append(MonthData(
            month=m,
            stitch_bill_total=data_dict[m]['stitch_bill'],
            employee_payment_total=data_dict[m]['employee_payment']
        ))
        
    return ChartDataResponse(data=chart_data)

@router.get("", response_model=List[ExpenseResponse])
async def list_expenses(
    type: Optional[str] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager)
):
    stmt = select(Expense).order_by(Expense.date.desc())
    if type:
        stmt = stmt.where(Expense.type == ExpenseType(type))
    res = await db.execute(stmt)
    return res.scalars().all()
