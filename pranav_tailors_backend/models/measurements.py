from sqlalchemy import (
    Column, Integer, Float, Boolean, ForeignKey, Index, UniqueConstraint
)
from sqlalchemy.orm import relationship
from .base import Base


class BlouseMeasurement(Base):
    """
    Stores all 13 blouse-specific measurements for a customer.
    One-to-one with Customer (enforced by unique constraint on customer_id).
    """
    __tablename__ = "blouse_measurements"

    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(
        Integer, ForeignKey("customers.id", ondelete="CASCADE"),
        nullable=False, unique=True
    )

    # ── Measurements (in inches, stored as Float for half-inch precision) ──────
    back_length = Column(Float, nullable=True)
    full_shoulder = Column(Float, nullable=True)
    shoulder_strap = Column(Float, nullable=True)
    back_neck_depth = Column(Float, nullable=True)
    front_neck_depth = Column(Float, nullable=True)
    shoulder_to_apex = Column(Float, nullable=True)
    front_length = Column(Float, nullable=True)
    chest = Column(Float, nullable=True)
    waist = Column(Float, nullable=True)
    sleeve_length = Column(Float, nullable=True)
    arm_round = Column(Float, nullable=True)
    sleeve_round = Column(Float, nullable=True)
    arm_hole = Column(Float, nullable=True)

    # Relationship
    customer = relationship("Customer", back_populates="blouse_measurement")

    __table_args__ = (
        Index("ix_blouse_measurements_customer_id", "customer_id"),
    )

    def __repr__(self) -> str:
        return f"<BlouseMeasurement customer_id={self.customer_id}>"


class DressMeasurement(Base):
    """
    Stores upper (13 blouse fields + seat) and lower measurements for dress,
    plus a dupatta boolean.
    One-to-one with Customer.
    """
    __tablename__ = "dress_measurements"

    id = Column(Integer, primary_key=True, index=True)
    customer_id = Column(
        Integer, ForeignKey("customers.id", ondelete="CASCADE"),
        nullable=False, unique=True
    )

    # ── Upper body (same 13 as blouse + seat) ─────────────────────────────────
    upper_back_length = Column(Float, nullable=True)
    upper_full_shoulder = Column(Float, nullable=True)
    upper_shoulder_strap = Column(Float, nullable=True)
    upper_back_neck_depth = Column(Float, nullable=True)
    upper_front_neck_depth = Column(Float, nullable=True)
    upper_shoulder_to_apex = Column(Float, nullable=True)
    upper_front_length = Column(Float, nullable=True)
    upper_chest = Column(Float, nullable=True)
    upper_waist = Column(Float, nullable=True)
    upper_sleeve_length = Column(Float, nullable=True)
    upper_arm_round = Column(Float, nullable=True)
    upper_sleeve_round = Column(Float, nullable=True)
    upper_arm_hole = Column(Float, nullable=True)
    upper_seat = Column(Float, nullable=True)          # extra field for dress

    # ── Lower body ─────────────────────────────────────────────────────────────
    lower_height = Column(Float, nullable=True)
    lower_waist = Column(Float, nullable=True)
    lower_seat = Column(Float, nullable=True)
    lower_bottom = Column(Float, nullable=True)

    # ── Extras ─────────────────────────────────────────────────────────────────
    dupatta = Column(Boolean, default=False, nullable=False)

    # Relationship
    customer = relationship("Customer", back_populates="dress_measurement")

    __table_args__ = (
        Index("ix_dress_measurements_customer_id", "customer_id"),
    )

    def __repr__(self) -> str:
        return f"<DressMeasurement customer_id={self.customer_id}>"
