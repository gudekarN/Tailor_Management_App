"""
WhatsApp messaging via Twilio.
"""
import logging
from typing import Optional

from twilio.rest import Client
from twilio.base.exceptions import TwilioRestException

from config import settings

logger = logging.getLogger(__name__)

_client: Optional[Client] = None


def _get_client() -> Optional[Client]:
    """Lazily create and cache the Twilio REST client."""
    global _client
    if _client is not None:
        return _client
    if not settings.TWILIO_ACCOUNT_SID or not settings.TWILIO_AUTH_TOKEN:
        logger.warning("Twilio credentials not set – WhatsApp messages disabled.")
        return None
    _client = Client(settings.TWILIO_ACCOUNT_SID, settings.TWILIO_AUTH_TOKEN)
    return _client


def send_whatsapp_message(to: str, message: str) -> bool:
    """
    Send a WhatsApp message via Twilio sandbox/production.

    Args:
        to:      Recipient phone number in E.164 format, e.g. '+919876543210'
        message: Plain text message body.

    Returns:
        True on success, False on failure.
    """
    client = _get_client()
    if not client:
        return False

    # Normalise 'to' to whatsapp: URI format
    to_uri = f"whatsapp:{to}" if not to.startswith("whatsapp:") else to

    try:
        msg = client.messages.create(
            from_=settings.TWILIO_WHATSAPP_FROM,
            to=to_uri,
            body=message,
        )
        logger.info("WhatsApp sent. SID=%s status=%s", msg.sid, msg.status)
        return True
    except TwilioRestException as exc:
        logger.error("Twilio WhatsApp error (code %s): %s", exc.code, exc.msg)
        return False
    except Exception as exc:
        logger.error("Unexpected WhatsApp error: %s", exc)
        return False
