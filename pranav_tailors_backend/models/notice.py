from datetime import datetime
from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Index
from sqlalchemy.orm import relationship
from .base import Base


class Notice(Base):
    """
    Notices/announcements created by manager, visible to all employees.
    """
    __tablename__ = "notices"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    message = Column(String(2000), nullable=False)
    created_by = Column(
        Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)
    is_active = Column(Boolean, default=True, nullable=False)

    # Relationship
    creator = relationship("User", back_populates="notices_created", foreign_keys=[created_by])

    __table_args__ = (
        Index("ix_notices_created_by", "created_by"),
        Index("ix_notices_is_active", "is_active"),
        Index("ix_notices_created_at", "created_at"),
    )

    def __repr__(self) -> str:
        return f"<Notice id={self.id} title={self.title!r} is_active={self.is_active}>"
