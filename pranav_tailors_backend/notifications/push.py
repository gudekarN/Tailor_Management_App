"""
FCM Push Notification module using Firebase Admin SDK.
Initialises the app lazily (once) on first use to avoid import-time errors
if the credentials file is missing in development.
"""
import logging
from typing import Optional

import firebase_admin
from firebase_admin import credentials, messaging
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from config import settings

logger = logging.getLogger(__name__)

_firebase_initialized = False


def _init_firebase() -> bool:
    """Initialise Firebase Admin SDK once. Returns True if successful."""
    global _firebase_initialized
    if _firebase_initialized:
        return True
    if not settings.FIREBASE_CREDENTIALS_PATH:
        logger.warning("FIREBASE_CREDENTIALS_PATH not set – push notifications disabled.")
        return False
    try:
        cred = credentials.Certificate(settings.FIREBASE_CREDENTIALS_PATH)
        firebase_admin.initialize_app(cred)
        _firebase_initialized = True
        logger.info("Firebase Admin SDK initialised successfully.")
        return True
    except Exception as exc:
        logger.error("Firebase initialisation failed: %s", exc)
        return False


async def send_push_notification(
    token: Optional[str],
    title: str,
    body: str,
    data: Optional[dict] = None,
) -> bool:
    """
    Send an FCM push notification to a single device token.

    Returns True if sent successfully, False otherwise.
    All values in `data` must be strings (FCM requirement).
    """
    if not token:
        logger.debug("send_push_notification: no token provided, skipping.")
        return False

    if not _init_firebase():
        return False

    # Stringify all data values (FCM enforces this)
    str_data = {k: str(v) for k, v in (data or {}).items()}

    try:
        message = messaging.Message(
            notification=messaging.Notification(title=title, body=body),
            data=str_data,
            token=token,
            android=messaging.AndroidConfig(priority="high"),
            apns=messaging.APNSConfig(
                payload=messaging.APNSPayload(
                    aps=messaging.Aps(sound="default")
                )
            ),
        )
        response = messaging.send(message)
        logger.info("FCM message sent. Response: %s", response)
        return True
    except messaging.UnregisteredError:
        logger.warning("FCM token unregistered: %s", token[:20])
        return False
    except Exception as exc:
        logger.error("FCM send failed: %s", exc)
        return False


async def send_push_to_managers(
    db: AsyncSession,
    title: str,
    body: str,
    data: Optional[dict] = None,
) -> int:
    """
    Fetch all active manager FCM tokens from DB and send push to all.

    Returns the number of successfully sent messages.
    """
    from models.user import User, UserRole  # local import to avoid circular deps

    stmt = select(User).where(
        User.role == UserRole.manager,
        User.is_active == True,
        User.fcm_token.isnot(None),
    )
    result = await db.execute(stmt)
    managers = result.scalars().all()

    sent = 0
    for manager in managers:
        success = await send_push_notification(
            token=manager.fcm_token,
            title=title,
            body=body,
            data=data,
        )
        if success:
            sent += 1

    logger.info("send_push_to_managers: sent %d/%d", sent, len(managers))
    return sent
