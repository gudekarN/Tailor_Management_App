from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from typing import List, Optional
from datetime import datetime
from collections import defaultdict

from database.database import get_db
from models.user import User, UserRole
from models.order import Order, OrderItem, OrderItemStatus, OrderStatus
from models.customer import Customer
from core.dependencies import require_any
from notifications.push import send_push_notification
from schemas.work_queue_schemas import (
    AssignRequest, SetNewDateRequest,
    WorkQueueItemResponse, CompletedOrderGroup
)

router = APIRouter()


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _get_item_with_order(item_id: int, db: AsyncSession) -> OrderItem:
    """Load an OrderItem with its parent Order, customer, and assignee eagerly."""
    stmt = (
        select(OrderItem)
        .options(
            selectinload(OrderItem.assignee),
            selectinload(OrderItem.order)
            .selectinload(Order.customer),
            selectinload(OrderItem.order)
            .selectinload(Order.items)
            .selectinload(OrderItem.assignee),
        )
        .where(OrderItem.id == item_id)
    )
    result = await db.execute(stmt)
    item = result.scalar_one_or_none()
    if not item:
        raise HTTPException(status_code=404, detail="Order item not found")
    return item


def _serialize_queue_item(item: OrderItem) -> dict:
    order = item.order
    return {
        "id": item.id,
        "order_id": item.order_id,
        "receipt_no": order.receipt_no if order else "",
        "customer_name": order.customer.name if (order and order.customer) else "",
        "delivery_date": order.delivery_date if order else None,
        "is_urgent": order.is_urgent if order else False,
        "item_name": item.item_name,
        "design_image_url": item.design_image_url,
        "price": item.price,
        "status": item.status,
        "assigned_to": item.assigned_to,
        "assignee_name": item.assignee.name if item.assignee else None,
        "completed_at": item.completed_at,
    }


# ── GET /work-queue ───────────────────────────────────────────────────────────

@router.get("", response_model=List[WorkQueueItemResponse])
async def get_work_queue(
    status_filter: Optional[str] = Query(None, alias="status"),
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    List all order items.
    Optional ?status=unassigned|in_progress|complete filter.
    Includes customer name, order delivery date, assignee name.
    """
    stmt = (
        select(OrderItem)
        .options(
            selectinload(OrderItem.assignee),
            selectinload(OrderItem.order).selectinload(Order.customer),
        )
        .join(OrderItem.order)
        .order_by(Order.delivery_date.asc(), OrderItem.id.asc())
    )

    if status_filter:
        try:
            stmt = stmt.where(OrderItem.status == OrderItemStatus(status_filter))
        except ValueError:
            raise HTTPException(
                status_code=400,
                detail=f"Invalid status '{status_filter}'. Use: unassigned, in_progress, complete"
            )

    result = await db.execute(stmt)
    items = result.scalars().all()
    return [_serialize_queue_item(i) for i in items]


# ── POST /work-queue/{item_id}/assign ─────────────────────────────────────────

@router.post("/{item_id}/assign", response_model=WorkQueueItemResponse)
async def assign_item(
    item_id: int,
    req: AssignRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Assign an order item to a user. Changes status to in_progress.
    Only unassigned items can be assigned via this endpoint.
    """
    item = await _get_item_with_order(item_id, db)

    if item.status != OrderItemStatus.unassigned:
        raise HTTPException(
            status_code=400,
            detail=f"Item is already '{item.status}'. Use /reassign to change assignee."
        )

    # Verify target user exists
    u_stmt = select(User).where(User.id == req.user_id, User.is_active == True)
    u_res = await db.execute(u_stmt)
    target_user = u_res.scalar_one_or_none()
    if not target_user:
        raise HTTPException(status_code=404, detail="Target user not found or inactive")

    item.assigned_to = req.user_id
    item.status = OrderItemStatus.in_progress

    # If parent order is still pending, bump it to in_progress
    if item.order.status == OrderStatus.pending:
        item.order.status = OrderStatus.in_progress

    await db.commit()
    await db.refresh(item)
    item = await _get_item_with_order(item_id, db)
    return _serialize_queue_item(item)


# ── PUT /work-queue/{item_id}/reassign ────────────────────────────────────────

@router.put("/{item_id}/reassign", response_model=WorkQueueItemResponse)
async def reassign_item(
    item_id: int,
    req: AssignRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Change the assignee of an in_progress item to a different user.
    Status remains in_progress.
    """
    item = await _get_item_with_order(item_id, db)

    if item.status == OrderItemStatus.complete:
        raise HTTPException(status_code=400, detail="Cannot reassign a completed item")

    # Verify target user exists
    u_stmt = select(User).where(User.id == req.user_id, User.is_active == True)
    u_res = await db.execute(u_stmt)
    target_user = u_res.scalar_one_or_none()
    if not target_user:
        raise HTTPException(status_code=404, detail="Target user not found or inactive")

    item.assigned_to = req.user_id
    # Ensure status is in_progress even if it was unassigned before
    item.status = OrderItemStatus.in_progress

    await db.commit()
    item = await _get_item_with_order(item_id, db)
    return _serialize_queue_item(item)


# ── POST /work-queue/{item_id}/set-new-date ───────────────────────────────────

@router.post("/{item_id}/set-new-date", response_model=WorkQueueItemResponse)
async def set_new_date(
    item_id: int,
    req: SetNewDateRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Update the delivery date on the parent order of any in_progress item.
    Works regardless of who the item is assigned to.
    """
    item = await _get_item_with_order(item_id, db)

    if item.status == OrderItemStatus.complete:
        raise HTTPException(
            status_code=400,
            detail="Cannot change delivery date via a completed item"
        )

    item.order.delivery_date = req.delivery_date
    await db.commit()

    item = await _get_item_with_order(item_id, db)
    return _serialize_queue_item(item)


# ── POST /work-queue/{item_id}/complete ──────────────────────────────────────

@router.post("/{item_id}/complete", response_model=WorkQueueItemResponse)
async def complete_item(
    item_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Mark an order item as complete. Sets completed_at to now.

    If ALL items of the parent order are now complete, the order status is
    updated to 'complete' and a push notification is sent to every active
    manager's FCM token.
    """
    item = await _get_item_with_order(item_id, db)

    if item.status == OrderItemStatus.complete:
        raise HTTPException(status_code=400, detail="Item is already complete")

    item.status = OrderItemStatus.complete
    item.completed_at = datetime.utcnow()

    await db.flush()

    # Check if all sibling items are now complete
    all_complete = all(
        sibling.status == OrderItemStatus.complete
        for sibling in item.order.items
    )

    if all_complete:
        item.order.status = OrderStatus.complete

        # Notify all active managers
        mgr_stmt = select(User).where(
            User.role == UserRole.manager,
            User.is_active == True,
            User.fcm_token.isnot(None),
        )
        mgr_res = await db.execute(mgr_stmt)
        managers = mgr_res.scalars().all()

        customer_name = item.order.customer.name if item.order.customer else "Customer"
        for manager in managers:
            await send_push_notification(
                fcm_token=manager.fcm_token,
                title="Order Complete ✅",
                body=f"All items for order {item.order.receipt_no} ({customer_name}) are done.",
                data={"order_id": str(item.order_id), "receipt_no": item.order.receipt_no},
            )

    await db.commit()
    item = await _get_item_with_order(item_id, db)
    return _serialize_queue_item(item)


# ── GET /work-queue/completed ─────────────────────────────────────────────────

@router.get("/completed", response_model=List[CompletedOrderGroup])
async def get_completed(
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_any),
):
    """
    Completed items grouped by order.
    Indicates whether the whole order is fully complete or only partially complete.
    """
    # Load all orders that have at least one completed item
    stmt = (
        select(Order)
        .options(
            selectinload(Order.customer),
            selectinload(Order.items).selectinload(OrderItem.assignee),
        )
        .join(Order.items)
        .where(OrderItem.status == OrderItemStatus.complete)
        .distinct()
        .order_by(Order.delivery_date.desc())
    )
    result = await db.execute(stmt)
    orders = result.scalars().unique().all()

    groups: List[CompletedOrderGroup] = []
    for order in orders:
        all_items = order.items
        completed_items = [i for i in all_items if i.status == OrderItemStatus.complete]

        groups.append(
            CompletedOrderGroup(
                order_id=order.id,
                receipt_no=order.receipt_no,
                customer_name=order.customer.name if order.customer else "",
                delivery_date=order.delivery_date,
                is_fully_complete=len(completed_items) == len(all_items),
                total_items=len(all_items),
                completed_items=len(completed_items),
                items=[_serialize_queue_item(i) for i in completed_items],
            )
        )

    return groups
