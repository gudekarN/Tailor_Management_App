import enum
from datetime import date
from sqlalchemy import (
    Column, Integer, Float, String, Date, ForeignKey, Enum as SAEnum, Index
)
from sqlalchemy.orm import relationship
from .base import Base


class ExpenseType(str, enum.Enum):
    stitch_bill = "stitch_bill"
    employee_payment = "employee_payment"


class EmployeePayment(Base):
    """
    Records salary / advance payments made to an employee.
    """
    __tablename__ = "employee_payments"

    id = Column(Integer, primary_key=True, index=True)
    employee_id = Column(
        Integer, ForeignKey("users.id", ondelete="RESTRICT"), nullable=False
    )
    amount = Column(Float, nullable=False)
    date = Column(Date, default=date.today, nullable=False)
    given_by = Column(
        Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    notes = Column(String(500), nullable=True)

    # Relationships
    employee = relationship(
        "User", back_populates="payments_received", foreign_keys=[employee_id]
    )
    giver = relationship(
        "User", back_populates="payments_given", foreign_keys=[given_by]
    )

    __table_args__ = (
        Index("ix_employee_payments_employee_id", "employee_id"),
        Index("ix_employee_payments_date", "date"),
        Index("ix_employee_payments_given_by", "given_by"),
    )

    def __repr__(self) -> str:
        return f"<EmployeePayment id={self.id} employee_id={self.employee_id} amount={self.amount}>"


class Expense(Base):
    """
    General expense ledger. reference_id links to the source record
    (e.g. EmployeePayment.id or an external stitch bill id).
    """
    __tablename__ = "expenses"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(SAEnum(ExpenseType), nullable=False)
    amount = Column(Float, nullable=False)
    date = Column(Date, default=date.today, nullable=False)
    reference_id = Column(Integer, nullable=True)   # nullable — some expenses have no linked record
    notes = Column(String(500), nullable=True)

    __table_args__ = (
        Index("ix_expenses_type", "type"),
        Index("ix_expenses_date", "date"),
    )

    def __repr__(self) -> str:
        return f"<Expense id={self.id} type={self.type} amount={self.amount}>"
