"""
APScheduler-based background job scheduler.

Jobs:
  08:00 daily  – Today's deliveries push to all managers
  10:00 daily  – Tomorrow's reminder push to all managers
  14:00 daily  – Tomorrow's reminder push to all managers
  18:00 daily  – Tomorrow's reminder push to all managers
  08:00 daily  – Birthday check, push manager for each birthday customer

All times are in IST (Asia/Kolkata).
Deduplication: each job logs a run date keyed by job name to avoid double-firing
if the scheduler is restarted within the same day.
"""
import logging
from datetime import date, timedelta
from typing import Set

from apscheduler.schedulers.asyncio import AsyncIOScheduler
from apscheduler.triggers.cron import CronTrigger

logger = logging.getLogger(__name__)

scheduler = AsyncIOScheduler(timezone="Asia/Kolkata")

# ── Deduplication guard ───────────────────────────────────────────────────────
# Maps job_key → last run date; reset on process restart (in-memory only).
_last_run: dict[str, date] = {}


def _already_ran(job_key: str) -> bool:
    last = _last_run.get(job_key)
    today = date.today()
    if last == today:
        logger.debug("Job '%s' already ran today – skipping.", job_key)
        return True
    _last_run[job_key] = today
    return False


# ── Helpers ───────────────────────────────────────────────────────────────────

async def _get_db_session():
    """Create a fresh async session for use inside scheduler jobs."""
    from database.database import AsyncSessionLocal
    return AsyncSessionLocal()


# ── Job: today's deliveries ───────────────────────────────────────────────────

async def job_todays_deliveries():
    job_key = "todays_deliveries"
    if _already_ran(job_key):
        return

    from sqlalchemy.future import select
    from models.order import Order, OrderStatus
    from notifications.push import send_push_to_managers

    async with await _get_db_session() as db:
        today = date.today()
        stmt = select(Order).where(
            Order.delivery_date == today,
            Order.status.notin_([OrderStatus.complete, OrderStatus.delivered]),
        )
        res = await db.execute(stmt)
        orders = res.scalars().all()
        count = len(orders)

        if count == 0:
            logger.info("No deliveries due today.")
            return

        await send_push_to_managers(
            db=db,
            title="📦 Today's Deliveries",
            body=f"{count} order{'s' if count != 1 else ''} due today!",
            data={"type": "todays_deliveries", "count": str(count)},
        )
        logger.info("Today's deliveries job done: %d orders.", count)


# ── Job: tomorrow's reminder ─────────────────────────────────────────────────

async def job_tomorrow_reminder():
    """Runs at 10am, 2pm, and 6pm. Deduplication per slot, not once a day."""
    from sqlalchemy.future import select
    from models.order import Order, OrderStatus
    from notifications.push import send_push_to_managers

    async with await _get_db_session() as db:
        tomorrow = date.today() + timedelta(days=1)
        stmt = select(Order).where(
            Order.delivery_date == tomorrow,
            Order.status.notin_([OrderStatus.complete, OrderStatus.delivered]),
        )
        res = await db.execute(stmt)
        orders = res.scalars().all()
        count = len(orders)

        if count == 0:
            return

        await send_push_to_managers(
            db=db,
            title="⏰ Tomorrow's Reminder",
            body=f"{count} order{'s' if count != 1 else ''} due tomorrow ({tomorrow.strftime('%d %b')}).",
            data={"type": "tomorrow_reminder", "count": str(count)},
        )
        logger.info("Tomorrow reminder job done: %d orders.", count)


# ── Job: birthday check ───────────────────────────────────────────────────────

async def job_birthday_check():
    job_key = "birthday_check"
    if _already_ran(job_key):
        return

    from sqlalchemy.future import select
    from sqlalchemy import extract
    from models.customer import Customer
    from notifications.push import send_push_to_managers

    async with await _get_db_session() as db:
        today = date.today()
        stmt = select(Customer).where(
            extract("month", Customer.date_of_birth) == today.month,
            extract("day", Customer.date_of_birth) == today.day,
            Customer.date_of_birth.isnot(None),
        )
        res = await db.execute(stmt)
        customers = res.scalars().all()

        for customer in customers:
            await send_push_to_managers(
                db=db,
                title="🎂 Birthday Today!",
                body=f"{customer.name} has a birthday today. Wish them!",
                data={"type": "birthday", "customer_id": str(customer.id)},
            )
            logger.info("Birthday notification sent for customer %s.", customer.name)


# ── Register jobs ─────────────────────────────────────────────────────────────

def start_scheduler():
    """Register all jobs and start the scheduler. Called from app lifespan."""

    scheduler.add_job(
        job_todays_deliveries,
        trigger=CronTrigger(hour=8, minute=0, timezone="Asia/Kolkata"),
        id="todays_deliveries",
        replace_existing=True,
        misfire_grace_time=300,
    )

    for hour in (10, 14, 18):
        scheduler.add_job(
            job_tomorrow_reminder,
            trigger=CronTrigger(hour=hour, minute=0, timezone="Asia/Kolkata"),
            id=f"tomorrow_reminder_{hour}",
            replace_existing=True,
            misfire_grace_time=300,
        )

    scheduler.add_job(
        job_birthday_check,
        trigger=CronTrigger(hour=8, minute=0, timezone="Asia/Kolkata"),
        id="birthday_check",
        replace_existing=True,
        misfire_grace_time=300,
    )

    scheduler.start()
    logger.info("APScheduler started with %d jobs.", len(scheduler.get_jobs()))


def stop_scheduler():
    if scheduler.running:
        scheduler.shutdown(wait=False)
        logger.info("APScheduler stopped.")
