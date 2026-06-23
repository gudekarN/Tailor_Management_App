"""Alembic environment – async SQLAlchemy with asyncpg."""
import asyncio
import os
import sys
from logging.config import fileConfig

from sqlalchemy import pool
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context

# ── Path setup ────────────────────────────────────────────────────────────────
# Make the project root importable
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

# ── App imports ───────────────────────────────────────────────────────────────
from config import settings
from models.base import Base

# Import all model modules so their tables are registered on Base.metadata
import models.user            # noqa: F401
import models.customer        # noqa: F401
import models.measurements    # noqa: F401
import models.order           # noqa: F401
import models.payment         # noqa: F401
import models.notice          # noqa: F401
import models.design_gallery  # noqa: F401
import models.message_template  # noqa: F401

# ── Alembic config ────────────────────────────────────────────────────────────
config = context.config

# Inject the DB URL from our settings (overrides blank value in alembic.ini)
config.set_main_option("sqlalchemy.url", settings.DATABASE_URL)

if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


# ── Offline migrations ────────────────────────────────────────────────────────
def run_migrations_offline() -> None:
    """Run migrations without a live DB connection (generates SQL script)."""
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()


# ── Online migrations ─────────────────────────────────────────────────────────
def do_run_migrations(connection):
    context.configure(connection=connection, target_metadata=target_metadata)
    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    """Run migrations using an async engine (required for asyncpg)."""
    connectable = async_engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )
    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)
    await connectable.dispose()


def run_migrations_online() -> None:
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
