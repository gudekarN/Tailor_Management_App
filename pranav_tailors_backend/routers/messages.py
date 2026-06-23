"""
Messages router — send WhatsApp notifications to customers.
All endpoints are manager-only.
"""
import logging
from datetime import date

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload

from database.database import get_db
from models.user import User
from models.order import Order, OrderItem, OrderItemStatus
from models.message_template import MessageTemplate, MessageType, MessageLanguage
from core.dependencies import require_manager
from notifications.whatsapp import send_whatsapp_message
from utils.pdf_generator import generate_receipt_pdf

logger = logging.getLogger(__name__)
router = APIRouter()


# ── Request schemas ───────────────────────────────────────────────────────────

class MessageRequest(BaseModel):
    order_id: int
    language: str = "english"


class OverdueApologyRequest(BaseModel):
    order_id: int
    new_delivery_date: date
    language: str = "english"


class ReceiptShareRequest(BaseModel):
    order_id: int
    language: str = "english"


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _load_order(order_id: int, db: AsyncSession) -> Order:
    stmt = (
        select(Order)
        .options(
            selectinload(Order.customer),
            selectinload(Order.items),
        )
        .where(Order.id == order_id)
    )
    res = await db.execute(stmt)
    order = res.scalar_one_or_none()
    if not order:
        raise HTTPException(status_code=404, detail="Order not found")
    if not order.customer:
        raise HTTPException(status_code=400, detail="Order has no associated customer")
    return order


async def _load_template(msg_type: MessageType, language: str, db: AsyncSession) -> MessageTemplate:
    try:
        lang_enum = MessageLanguage(language)
    except ValueError:
        raise HTTPException(status_code=400, detail=f"Invalid language '{language}'. Use: english, marathi")

    stmt = select(MessageTemplate).where(
        MessageTemplate.type == msg_type,
        MessageTemplate.language == lang_enum,
    )
    res = await db.execute(stmt)
    tmpl = res.scalar_one_or_none()
    if not tmpl:
        raise HTTPException(
            status_code=404,
            detail=f"No template found for type={msg_type.value} language={language}"
        )
    return tmpl


def _format(template_text: str, **kwargs) -> str:
    try:
        return template_text.format(**kwargs)
    except KeyError as e:
        logger.warning("Template missing placeholder: %s", e)
        return template_text


# ── POST /messages/partial-complete ──────────────────────────────────────────

@router.post("/partial-complete")
async def send_partial_complete(
    req: MessageRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager),
):
    order = await _load_order(req.order_id, db)
    tmpl = await _load_template(MessageType.partial_complete, req.language, db)

    completed = [i for i in order.items if i.status == OrderItemStatus.complete]
    pending   = [i for i in order.items if i.status != OrderItemStatus.complete]

    if not completed:
        raise HTTPException(status_code=400, detail="No completed items in this order yet")

    completed_str = ", ".join(i.item_name for i in completed)
    pending_str   = ", ".join(i.item_name for i in pending) if pending else "None"

    text = _format(
        tmpl.template_text,
        customer_name=order.customer.name,
        completed_item=completed_str,
        pending_items=pending_str,
    )

    sent = send_whatsapp_message(to=order.customer.phone, message=text)
    return {"sent": sent, "to": order.customer.phone, "message": text}


# ── POST /messages/order-complete ────────────────────────────────────────────

@router.post("/order-complete")
async def send_order_complete(
    req: MessageRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager),
):
    order = await _load_order(req.order_id, db)
    tmpl = await _load_template(MessageType.order_complete, req.language, db)

    items_list = ", ".join(i.item_name for i in order.items)
    text = _format(
        tmpl.template_text,
        customer_name=order.customer.name,
        items_list=items_list,
    )

    sent = send_whatsapp_message(to=order.customer.phone, message=text)
    return {"sent": sent, "to": order.customer.phone, "message": text}


# ── POST /messages/overdue-apology ───────────────────────────────────────────

@router.post("/overdue-apology")
async def send_overdue_apology(
    req: OverdueApologyRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager),
):
    order = await _load_order(req.order_id, db)
    tmpl = await _load_template(MessageType.overdue_apology, req.language, db)

    # Update delivery date on order
    order.delivery_date = req.new_delivery_date
    await db.commit()

    formatted_date = req.new_delivery_date.strftime("%d %b %Y")
    text = _format(
        tmpl.template_text,
        customer_name=order.customer.name,
        new_delivery_date=formatted_date,
    )

    sent = send_whatsapp_message(to=order.customer.phone, message=text)
    return {
        "sent": sent,
        "to": order.customer.phone,
        "message": text,
        "new_delivery_date": req.new_delivery_date,
    }


# ── POST /messages/receipt-share ─────────────────────────────────────────────

@router.post("/receipt-share")
async def send_receipt_share(
    req: ReceiptShareRequest,
    db: AsyncSession = Depends(get_db),
    current_user: User = Depends(require_manager),
):
    order = await _load_order(req.order_id, db)

    # Generate PDF
    pdf_path = await generate_receipt_pdf(order_id=req.order_id, db=db)
    filename  = pdf_path.split(os.sep)[-1] if os.sep in pdf_path else pdf_path.split("/")[-1]
    pdf_url   = f"/static/receipts/{filename}"

    items_list = ", ".join(i.item_name for i in order.items)
    text = (
        f"Dear {order.customer.name}, please find your receipt for order "
        f"{order.receipt_no}. Items: {items_list}. "
        f"Total: ₹{order.total:.2f} | Paid: ₹{order.advance_paid:.2f} | "
        f"Remaining: ₹{order.remaining:.2f}. "
        f"Receipt: [PDF sent separately] - Pranav Ladies Tailors"
    )

    sent = send_whatsapp_message(to=order.customer.phone, message=text)
    return {
        "sent": sent,
        "to": order.customer.phone,
        "message": text,
        "pdf_url": pdf_url,
    }


import os
