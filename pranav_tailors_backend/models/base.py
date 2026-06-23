"""
Shared declarative base for all SQLAlchemy models.
Import Base from here – never re-create it in individual model files.
"""
from sqlalchemy.orm import declarative_base

Base = declarative_base()
