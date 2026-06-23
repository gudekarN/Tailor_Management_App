import enum
from datetime import datetime
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Enum as SAEnum, Index
from sqlalchemy.orm import relationship
from .base import Base


class GalleryType(str, enum.Enum):
    blouse = "blouse"
    dress = "dress"


class DesignGallery(Base):
    """
    Design reference images uploaded by manager/employee to the gallery.
    """
    __tablename__ = "design_gallery"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(SAEnum(GalleryType), nullable=False)
    image_url = Column(String(500), nullable=False)
    uploaded_by = Column(
        Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True
    )
    created_at = Column(DateTime, default=datetime.utcnow, nullable=False)

    # Relationship
    uploader = relationship("User", back_populates="gallery_uploads", foreign_keys=[uploaded_by])

    __table_args__ = (
        Index("ix_design_gallery_type", "type"),
        Index("ix_design_gallery_uploaded_by", "uploaded_by"),
        Index("ix_design_gallery_created_at", "created_at"),
    )

    def __repr__(self) -> str:
        return f"<DesignGallery id={self.id} type={self.type}>"
