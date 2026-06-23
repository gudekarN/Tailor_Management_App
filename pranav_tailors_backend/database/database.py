from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from config import settings
from models.base import Base  # shared Base – models register against this

engine = create_async_engine(settings.DATABASE_URL, echo=True, future=True)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)


async def get_db():
    """FastAPI dependency – yields an async DB session."""
    async with AsyncSessionLocal() as session:
        yield session


async def create_all_tables():
    """Helper to create all tables (development use only – prefer Alembic migrations)."""
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
