# app/core/db.py
from __future__ import annotations

import os
from functools import lru_cache
from typing import Generator

from sqlalchemy import create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.core.config import get_settings


class Base(DeclarativeBase):
    """Base declarativa para modelos SQLAlchemy."""


def _database_url() -> str:
    # 1) Entorno (tests, CI, docker)
    env_url = os.getenv("DATABASE_URL")
    if env_url:
        return env_url

    # 2) Settings (local)
    return get_settings().DATABASE_URL


@lru_cache(maxsize=1)
def get_engine():
    # pool_pre_ping evita conexiones rotas en dev
    return create_engine(_database_url(), pool_pre_ping=True)


@lru_cache(maxsize=1)
def get_sessionmaker():
    # Esto es lo que te está importando app/core/deps.py
    return sessionmaker(
        bind=get_engine(),
        autocommit=False,
        autoflush=False,
        class_=Session,
    )


def get_db() -> Generator[Session, None, None]:
    """
    Dependency/fixture-friendly: genera una sesión y la cierra.
    """
    SessionLocal = get_sessionmaker()
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
