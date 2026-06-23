"""
Seed default WhatsApp/SMS message templates into the database on startup.
Skips existing entries to make the function idempotent.
"""
import logging
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from models.message_template import MessageTemplate, MessageType, MessageLanguage

logger = logging.getLogger(__name__)

TEMPLATES = [
    # ── partial_complete ───────────────────────────────────────────────────────
    {
        "type": MessageType.partial_complete,
        "language": MessageLanguage.english,
        "template_text": (
            "Dear {customer_name}, your {completed_item} is ready for pickup. "
            "Remaining items: {pending_items}. "
            "We will notify you when everything is ready. - Pranav Ladies Tailors"
        ),
    },
    {
        "type": MessageType.partial_complete,
        "language": MessageLanguage.marathi,
        "template_text": (
            "प्रिय {customer_name}, तुमचे {completed_item} तयार आहे. "
            "बाकी वस्तू: {pending_items}. "
            "सर्व तयार झाल्यावर कळवू. - प्रणव लेडीज टेलर्स"
        ),
    },
    # ── order_complete ─────────────────────────────────────────────────────────
    {
        "type": MessageType.order_complete,
        "language": MessageLanguage.english,
        "template_text": (
            "Dear {customer_name}, your complete order is ready for pickup! "
            "Items: {items_list}. "
            "Please collect at your earliest convenience. - Pranav Ladies Tailors"
        ),
    },
    {
        "type": MessageType.order_complete,
        "language": MessageLanguage.marathi,
        "template_text": (
            "प्रिय {customer_name}, तुमची संपूर्ण ऑर्डर तयार आहे! "
            "वस्तू: {items_list}. "
            "लवकरात लवकर घेऊन जा. - प्रणव लेडीज टेलर्स"
        ),
    },
    # ── overdue_apology ────────────────────────────────────────────────────────
    {
        "type": MessageType.overdue_apology,
        "language": MessageLanguage.english,
        "template_text": (
            "Dear {customer_name}, we sincerely apologize for the delay. "
            "Your order will be ready by {new_delivery_date}. "
            "We regret the inconvenience. - Pranav Ladies Tailors"
        ),
    },
    {
        "type": MessageType.overdue_apology,
        "language": MessageLanguage.marathi,
        "template_text": (
            "प्रिय {customer_name}, उशिरासाठी माफी मागतो. "
            "तुमची ऑर्डर {new_delivery_date} पर्यंत तयार होईल. "
            "- प्रणव लेडीज टेलर्स"
        ),
    },
    # ── tomorrow_reminder ──────────────────────────────────────────────────────
    {
        "type": MessageType.tomorrow_reminder,
        "language": MessageLanguage.english,
        "template_text": (
            "Reminder: {customer_name}'s order is due tomorrow ({delivery_date}). "
            "Items: {items_list}. - Pranav Ladies Tailors"
        ),
    },
    {
        "type": MessageType.tomorrow_reminder,
        "language": MessageLanguage.marathi,
        "template_text": (
            "आठवण: {customer_name} यांची ऑर्डर उद्या ({delivery_date}) द्यायची आहे. "
            "वस्तू: {items_list}. - प्रणव लेडीज टेलर्स"
        ),
    },
]


async def seed_message_templates(db: AsyncSession) -> None:
    """
    Insert default message templates if they don't already exist.
    Safe to call on every startup.
    """
    inserted = 0
    for tmpl in TEMPLATES:
        stmt = select(MessageTemplate).where(
            MessageTemplate.type == tmpl["type"],
            MessageTemplate.language == tmpl["language"],
        )
        res = await db.execute(stmt)
        existing = res.scalar_one_or_none()

        if not existing:
            db.add(MessageTemplate(**tmpl))
            inserted += 1

    if inserted:
        await db.commit()
        logger.info("Seeded %d message template(s).", inserted)
    else:
        logger.debug("All message templates already exist, nothing to seed.")
