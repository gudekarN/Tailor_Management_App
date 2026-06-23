import enum
from sqlalchemy import Column, Integer, String, Text, Enum as SAEnum, Index, UniqueConstraint
from .base import Base


class MessageType(str, enum.Enum):
    partial_complete = "partial_complete"
    order_complete = "order_complete"
    overdue_apology = "overdue_apology"
    tomorrow_reminder = "tomorrow_reminder"


class MessageLanguage(str, enum.Enum):
    english = "english"
    marathi = "marathi"


class MessageTemplate(Base):
    """
    Reusable WhatsApp / SMS message templates.
    Each (type, language) combination is unique.
    Template text may contain placeholders like {customer_name}, {delivery_date}.
    """
    __tablename__ = "message_templates"

    id = Column(Integer, primary_key=True, index=True)
    type = Column(SAEnum(MessageType), nullable=False)
    language = Column(SAEnum(MessageLanguage), nullable=False)
    template_text = Column(Text, nullable=False)

    __table_args__ = (
        UniqueConstraint("type", "language", name="uq_message_template_type_language"),
        Index("ix_message_templates_type", "type"),
        Index("ix_message_templates_language", "language"),
    )

    def __repr__(self) -> str:
        return f"<MessageTemplate type={self.type} language={self.language}>"
