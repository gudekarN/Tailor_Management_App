import enum
from datetime import date, datetime
from sqlalchemy import (
    Column, Integer, String, Float, Boolean, Date, DateTime,
    ForeignKey, Enum as SAEnum, Index, Sequence, event
)
from sqlalchemy.orm import relationship
from .base import Base


class OrderStatus(str, enum.Enum):
    pending = "pending"
    in_progress = "in_progress"
    complete = "complete"
    delivered = "delivered"


class OrderItemStatus(str, enum.Enum):
    unassigned = "unassigned"
    in_progress = "in_progress"
    complete = "complete"


# ── Receipt Number auto-generation ────────────────────────────────────────────
# Format: PT-YYYYMM-XXXX (e.g. PT-202606-0001)
# The sequence resets per-month via a DB trigger or application logic.
# Here we use a simple approach: store as String and set in a before_insert event.

class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    receipt_no = Column(String(20), unique=True, nullable=False, index=True)
    customer_id = Column(
        Integer, ForeignKey("customers.id", ondelete="RESTRICT"), nullable=False
    )
    design_extra_charge = Column(Float, default=0.0, nullable=False)
    is_urgent = Column(Boolean, default=False, nullable=False)
    urgent_cost = Column(Float, default=0.0, nullable=False)
    total = Column(Float, nullable=False)
    advance_paid = Column(Float, default=0.0, nullable=False)
    remaining = Column(Float, nullable=False)       # = total - advance_paid, can be updated
    delivery_date = Column(Date, nullable=False)
    generated_by = Column(
        Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    status = Column(SAEnum(OrderStatus), default=OrderStatus.pending, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationships
    customer = relationship("Customer", back_populates="orders")
    generator = relationship("User", back_populates="generated_orders", foreign_keys=[generated_by])
    items = relationship("OrderItem", back_populates="order", cascade="all, delete-orphan")
    sample_images = relationship("OrderSampleImage", back_populates="order", cascade="all, delete-orphan")

    __table_args__ = (
        Index("ix_orders_customer_id", "customer_id"),
        Index("ix_orders_status", "status"),
        Index("ix_orders_delivery_date", "delivery_date"),
        Index("ix_orders_generated_by", "generated_by"),
    )

    def __repr__(self) -> str:
        return f"<Order id={self.id} receipt_no={self.receipt_no!r} status={self.status}>"


@event.listens_for(Order, "before_insert")
def generate_receipt_no(mapper, connection, target: Order):
    """
    Auto-generate receipt number in format PT-YYYYMM-XXXX before insert.
    Counts existing orders for the current month and increments.
    """
    if target.receipt_no:
        return  # already set, skip
    today = date.today()
    prefix = f"PT-{today.strftime('%Y%m')}-"
    # Count orders this month to determine sequence number
    result = connection.execute(
        __import__("sqlalchemy").text(
            "SELECT COUNT(*) FROM orders WHERE receipt_no LIKE :prefix"
        ),
        {"prefix": f"{prefix}%"},
    )
    count = result.scalar() or 0
    target.receipt_no = f"{prefix}{(count + 1):04d}"


class OrderItem(Base):
    __tablename__ = "order_items"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(
        Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False
    )
    item_name = Column(String(100), nullable=False)
    design_image_url = Column(String(500), nullable=True)
    price = Column(Float, nullable=False)
    assigned_to = Column(
        Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    status = Column(
        SAEnum(OrderItemStatus), default=OrderItemStatus.unassigned, nullable=False
    )
    completed_at = Column(DateTime, nullable=True)

    # Relationships
    order = relationship("Order", back_populates="items")
    assignee = relationship("User", back_populates="assigned_items", foreign_keys=[assigned_to])

    __table_args__ = (
        Index("ix_order_items_order_id", "order_id"),
        Index("ix_order_items_assigned_to", "assigned_to"),
        Index("ix_order_items_status", "status"),
    )

    def __repr__(self) -> str:
        return f"<OrderItem id={self.id} item={self.item_name!r} status={self.status}>"


class OrderSampleImage(Base):
    __tablename__ = "order_sample_images"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(
        Integer, ForeignKey("orders.id", ondelete="CASCADE"), nullable=False
    )
    image_url = Column(String(500), nullable=False)

    # Relationship
    order = relationship("Order", back_populates="sample_images")

    __table_args__ = (
        Index("ix_order_sample_images_order_id", "order_id"),
    )

    def __repr__(self) -> str:
        return f"<OrderSampleImage id={self.id} order_id={self.order_id}>"
