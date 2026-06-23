from datetime import date
from sqlalchemy import Column, Integer, String, Date, ForeignKey, Index
from sqlalchemy.orm import relationship
from .base import Base


class Customer(Base):
    __tablename__ = "customers"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    date_of_birth = Column(Date, nullable=True)   # age is computed at runtime
    phone = Column(String(15), nullable=False, unique=True)
    address = Column(String(300), nullable=True)
    created_by = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    created_at = Column(Date, default=date.today, nullable=False)

    # Relationships
    creator = relationship("User", back_populates="created_customers", foreign_keys=[created_by])
    blouse_measurement = relationship(
        "BlouseMeasurement", back_populates="customer", uselist=False, cascade="all, delete-orphan"
    )
    dress_measurement = relationship(
        "DressMeasurement", back_populates="customer", uselist=False, cascade="all, delete-orphan"
    )
    orders = relationship("Order", back_populates="customer", cascade="all, delete-orphan")

    __table_args__ = (
        Index("ix_customers_phone", "phone"),
        Index("ix_customers_name", "name"),
        Index("ix_customers_created_by", "created_by"),
    )

    @property
    def age(self) -> int | None:
        """Compute age dynamically from date_of_birth."""
        if self.date_of_birth is None:
            return None
        today = date.today()
        dob = self.date_of_birth
        return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))

    def __repr__(self) -> str:
        return f"<Customer id={self.id} name={self.name!r}>"
