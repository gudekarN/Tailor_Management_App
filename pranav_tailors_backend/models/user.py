import enum
from sqlalchemy import Column, Integer, String, Boolean, Enum as SAEnum, Index
from sqlalchemy.orm import relationship
from .base import Base


class UserRole(str, enum.Enum):
    manager = "manager"
    employee = "employee"


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    phone = Column(String(15), nullable=False, unique=True)
    role = Column(SAEnum(UserRole), nullable=False, default=UserRole.employee)
    pin_hash = Column(String(255), nullable=False)
    fcm_token = Column(String(512), nullable=True)
    is_active = Column(Boolean, default=True, nullable=False)

    # Relationships
    created_customers = relationship(
        "Customer", back_populates="creator", foreign_keys="Customer.created_by"
    )
    generated_orders = relationship(
        "Order", back_populates="generator", foreign_keys="Order.generated_by"
    )
    assigned_items = relationship(
        "OrderItem", back_populates="assignee", foreign_keys="OrderItem.assigned_to"
    )
    payments_received = relationship(
        "EmployeePayment", back_populates="employee", foreign_keys="EmployeePayment.employee_id"
    )
    payments_given = relationship(
        "EmployeePayment", back_populates="giver", foreign_keys="EmployeePayment.given_by"
    )
    notices_created = relationship(
        "Notice", back_populates="creator", foreign_keys="Notice.created_by"
    )
    gallery_uploads = relationship(
        "DesignGallery", back_populates="uploader", foreign_keys="DesignGallery.uploaded_by"
    )

    __table_args__ = (
        Index("ix_users_phone", "phone"),
        Index("ix_users_role", "role"),
    )

    def __repr__(self) -> str:
        return f"<User id={self.id} name={self.name!r} role={self.role}>"
