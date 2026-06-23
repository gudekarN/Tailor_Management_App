from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy import or_
from typing import List, Optional
from datetime import date, datetime

from database.database import get_db
from models.user import User
from models.customer import Customer
from models.order import Order, OrderItem, OrderSampleImage, OrderStatus, OrderItemStatus
from models.payment import Expense, ExpenseType
from core.dependencies import require_any
from schemas.order_schemas import (
    OrderCreate, OrderUpdate, OrderListItem, OrderDetailResponse, OrderItemResponse,
    OrderSampleImageResponse
)

router = APIRouter()


def _build_order_list_item(order: Order) -> dict:
    """Helper: build flat dict for OrderListItem from ORM object."""
    return {
        **{c: getattr(order, c) for c in [
            "id", "receipt_no", "customer_id", "design_extra_charge",
            "is_urgent", "urgent_cost", "total", "advance_paid",
            "remaining", "delivery_date", "generated_by", "status", "created_at"
        ]},
        "customer_name": order.customer.name if order.customer else None,
    }


def _build_item_response(item: OrderItem) -> dict:
    return {
        "id": item.id,
        "order_id": item.order_id,
        "item_name": item.item_name,
        "design_image_url": item.design_image_url,
        "price": item.price,
        "assigned_to": item.assigned_to,
        "assignee_name": item.assignee.name if item.assignee else None,
        "status": item.status,
        "completed_at": item.completed_at,
    }


# ── POST /orders ──────────────────────────────────────────────────────────────

@router.post("", response_model=OrderDetailResponse, status_code=status.HTTP_201_CREATED)
async def create_order(
    req: OrderCreate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    # Verify customer exists
    c_stmt = select(Customer).options(
        selectinload(Customer.blouse_measurement),
        selectinload(Customer.dress_measurement),
    ).where(Customer.id == req.customer_id)
    c_res = await db.execute(c_stmt)
    customer = c_res.scalar_one_or_none()
    if not customer:
        raise HTTPException(status_code=404, detail="Customer not found")

    remaining = req.total - req.advance_paid

    # receipt_no is auto-generated via before_insert event listener on the model
    order = Order(
        customer_id=req.customer_id,
        design_extra_charge=req.design_extra_charge,
        is_urgent=req.is_urgent,
        urgent_cost=req.urgent_cost,
        total=req.total,
        advance_paid=req.advance_paid,
        remaining=remaining,
        delivery_date=req.delivery_date,
        generated_by=current_user.id,
        status=OrderStatus.pending,
    )
    db.add(order)
    await db.flush()  # get order.id before adding children

    # Create OrderItems
    for item_data in req.items:
        item = OrderItem(
            order_id=order.id,
            item_name=item_data.item_name,
            design_image_url=item_data.design_image_url,
            price=item_data.price,
            status=OrderItemStatus.unassigned,
        )
        db.add(item)

    # Create OrderSampleImages
    for img_data in req.sample_images:
        img = OrderSampleImage(order_id=order.id, image_url=img_data.image_url)
        db.add(img)

    # Auto-create Expense entry of type stitch_bill
    expense = Expense(
        type=ExpenseType.stitch_bill,
        amount=req.total,
        date=date.today(),
        reference_id=order.id,
        notes=f"Auto-created for order {order.receipt_no}",
    )
    db.add(expense)

    await db.commit()

    # Re-fetch with all relationships
    stmt = select(Order).options(
        selectinload(Order.customer).selectinload(Customer.blouse_measurement),
        selectinload(Order.customer).selectinload(Customer.dress_measurement),
        selectinload(Order.items).selectinload(OrderItem.assignee),
        selectinload(Order.sample_images),
    ).where(Order.id == order.id)
    res = await db.execute(stmt)
    order = res.scalar_one()

    return _serialize_order_detail(order)


# ── GET /orders ───────────────────────────────────────────────────────────────

@router.get("", response_model=List[OrderListItem])
async def list_orders(
    status_filter: Optional[str] = Query(None, alias="status"),
    urgent: Optional[bool] = Query(None),
    date_filter: Optional[date] = Query(None, alias="date"),
    employee_id: Optional[int] = Query(None),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    stmt = select(Order).options(
        selectinload(Order.customer),
        selectinload(Order.items),
    )

    if status_filter:
        try:
            stmt = stmt.where(Order.status == OrderStatus(status_filter))
        except ValueError:
            raise HTTPException(status_code=400, detail=f"Invalid status value: {status_filter}")

    if urgent is not None:
        stmt = stmt.where(Order.is_urgent == urgent)

    if date_filter:
        stmt = stmt.where(Order.delivery_date == date_filter)

    if employee_id:
        # Filter orders that have at least one item assigned to this employee
        stmt = stmt.join(Order.items).where(OrderItem.assigned_to == employee_id).distinct()

    result = await db.execute(stmt)
    orders = result.scalars().all()
    return [_build_order_list_item(o) for o in orders]


# ── GET /orders/delivery-dues ─────────────────────────────────────────────────

@router.get("/delivery-dues", response_model=List[OrderListItem])
async def delivery_dues(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    today = date.today()
    stmt = select(Order).options(selectinload(Order.customer)).where(
        Order.delivery_date <= today,
        Order.status.notin_([OrderStatus.complete, OrderStatus.delivered]),
    )
    result = await db.execute(stmt)
    orders = result.scalars().all()
    return [_build_order_list_item(o) for o in orders]


# ── GET /orders/{id} ─────────────────────────────────────────────────────────

@router.get("/{id}", response_model=OrderDetailResponse)
async def get_order(
    id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    stmt = select(Order).options(
        selectinload(Order.customer).selectinload(Customer.blouse_measurement),
        selectinload(Order.customer).selectinload(Customer.dress_measurement),
        selectinload(Order.items).selectinload(OrderItem.assignee),
        selectinload(Order.sample_images),
    ).where(Order.id == id)
    result = await db.execute(stmt)
    order = result.scalar_one_or_none()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    return _serialize_order_detail(order)


# ── PUT /orders/{id} ─────────────────────────────────────────────────────────

@router.put("/{id}", response_model=OrderListItem)
async def update_order(
    id: int,
    req: OrderUpdate,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    stmt = select(Order).options(selectinload(Order.customer)).where(Order.id == id)
    result = await db.execute(stmt)
    order = result.scalar_one_or_none()

    if not order:
        raise HTTPException(status_code=404, detail="Order not found")

    update_data = req.model_dump(exclude_unset=True)

    # Recalculate remaining if total or advance_paid changes
    new_total = update_data.get("total", order.total)
    new_advance = update_data.get("advance_paid", order.advance_paid)
    if "total" in update_data or "advance_paid" in update_data:
        update_data["remaining"] = new_total - new_advance

    for key, value in update_data.items():
        setattr(order, key, value)

    await db.commit()
    await db.refresh(order)
    return _build_order_list_item(order)


# ── Serialization helper ──────────────────────────────────────────────────────

def _serialize_order_detail(order: Order) -> dict:
    customer = order.customer
    return {
        "id": order.id,
        "receipt_no": order.receipt_no,
        "customer": {
            "id": customer.id,
            "name": customer.name,
            "phone": customer.phone,
            "blouse_measurement": customer.blouse_measurement,
            "dress_measurement": customer.dress_measurement,
        },
        "design_extra_charge": order.design_extra_charge,
        "is_urgent": order.is_urgent,
        "urgent_cost": order.urgent_cost,
        "total": order.total,
        "advance_paid": order.advance_paid,
        "remaining": order.remaining,
        "delivery_date": order.delivery_date,
        "generated_by": order.generated_by,
        "status": order.status,
        "created_at": order.created_at,
        "items": [_build_item_response(i) for i in order.items],
        "sample_images": [
            {"id": img.id, "order_id": img.order_id, "image_url": img.image_url}
            for img in order.sample_images
        ],
    }
