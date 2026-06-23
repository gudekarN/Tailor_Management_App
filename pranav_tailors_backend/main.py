from contextlib import asynccontextmanager
import logging
import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from config import settings
from routers import (
    auth, customers, orders, work_queue,
    employees, payments, expenses, notices, designs,
    messages, receipts,
)

logger = logging.getLogger(__name__)

# Ensure upload directories exist before mounting
os.makedirs("uploads/designs",  exist_ok=True)
os.makedirs("uploads/receipts", exist_ok=True)


# ── App lifespan ──────────────────────────────────────────────────────────────

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup and shutdown logic using the modern lifespan pattern."""
    # ── Startup ────────────────────────────────────────────────────────────────
    logger.info("Starting up Pranav Ladies Tailors Backend...")

    # Seed default message templates
    from database.database import AsyncSessionLocal
    from utils.seed_templates import seed_message_templates
    async with AsyncSessionLocal() as db:
        await seed_message_templates(db)

    # Start APScheduler background jobs
    from notifications.scheduler import start_scheduler
    start_scheduler()

    logger.info("Startup complete.")
    yield

    # ── Shutdown ───────────────────────────────────────────────────────────────
    from notifications.scheduler import stop_scheduler
    stop_scheduler()
    logger.info("Shutdown complete.")


# ── Application ───────────────────────────────────────────────────────────────

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Pranav Ladies Tailors — Management Backend API",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS configured for mobile app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve uploaded files at /static (designs, receipts, etc.)
app.mount("/static", StaticFiles(directory="uploads"), name="static")

# ── Routers ───────────────────────────────────────────────────────────────────
app.include_router(auth.router,        prefix="/auth",        tags=["Auth"])
app.include_router(customers.router,   prefix="/customers",   tags=["Customers"])
app.include_router(orders.router,      prefix="/orders",      tags=["Orders"])
app.include_router(work_queue.router,  prefix="/work-queue",  tags=["Work Queue"])
app.include_router(employees.router,   prefix="/employees",   tags=["Employees"])
app.include_router(payments.router,    prefix="/payments",    tags=["Payments"])
app.include_router(expenses.router,    prefix="/expenses",    tags=["Expenses"])
app.include_router(notices.router,     prefix="/notices",     tags=["Notices"])
app.include_router(designs.router,     prefix="/designs",     tags=["Design Gallery"])
app.include_router(messages.router,    prefix="/messages",    tags=["Messages"])
app.include_router(receipts.router,    prefix="/receipts",    tags=["Receipts"])


@app.get("/", tags=["Health"])
async def root():
    return {"message": f"Welcome to {settings.PROJECT_NAME} API", "status": "ok"}
