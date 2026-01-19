import os
import subprocess
import time
from typing import Optional

import pytest

# --- FIX (tests): setear ENV ANTES de importar cualquier app.* ---
# Motivo: app.core.config crea `settings` en import-time (y lo cachea con lru_cache).
# Si esto se hace en un fixture, Pytest ya habra importado `app.*` durante la coleccion.
os.environ.setdefault("ENVIRONMENT", "test")
os.environ.setdefault("ENV", "test")
os.environ.setdefault("APP_ENV", "test")
os.environ.setdefault("LOG_LEVEL", "INFO")

# Defaults DB tests (si no vienen ya desde fuera)
os.environ.setdefault("CATALOG_DB_HOST", "127.0.0.1")
os.environ.setdefault("CATALOG_DB_PORT", "5434")
os.environ.setdefault("CATALOG_DB_NAME", "catalog_test_db")
os.environ.setdefault("CATALOG_DB_USER", "catalog_test_app")
os.environ.setdefault("CATALOG_DB_PASSWORD", "catalog_test_app_pwd")


def _wait_for_tcp(host: str, port: int, timeout_s: float = 20.0) -> None:
    start = time.time()
    last_err: Optional[Exception] = None

    while time.time() - start < timeout_s:
        try:
            import socket

            with socket.create_connection((host, port), timeout=1.0):
                return
        except Exception as e:  # noqa: BLE001
            last_err = e
            time.sleep(0.25)

    raise RuntimeError(
        f"TCP no disponible en {host}:{port} tras {timeout_s}s. "
        f"Ultimo error: {last_err}"
    )


def _get_test_db_settings() -> dict[str, str]:
    """
    Lee la config de DB de tests desde ENV con defaults seguros.
    Evita KeyError y centraliza la fuente de verdad.
    """
    host = os.getenv("CATALOG_DB_HOST", "127.0.0.1")
    port = os.getenv("CATALOG_DB_PORT", "5434")
    db = os.getenv("CATALOG_DB_NAME", "catalog_test_db")
    user = os.getenv("CATALOG_DB_USER", "catalog_test_app")
    password = os.getenv("CATALOG_DB_PASSWORD", "catalog_test_app_pwd")

    # --- FIX (tests): validacion explicita para evitar valores vacios ---
    missing = [
        k
        for k, v in {
            "CATALOG_DB_HOST": host,
            "CATALOG_DB_PORT": port,
            "CATALOG_DB_NAME": db,
            "CATALOG_DB_USER": user,
            "CATALOG_DB_PASSWORD": password,
        }.items()
        if not v
    ]
    if missing:
        raise RuntimeError(
            "Faltan variables de entorno de la DB de tests: "
            f"{', '.join(missing)}"
        )

    return {
        "host": host,
        "port": port,
        "db": db,
        "user": user,
        "password": password,
    }


def _set_database_url_env() -> None:
    # --- FIX (tests): setear DATABASE_URL desde las variables de DB de tests ---
    dbs = _get_test_db_settings()
    os.environ["DATABASE_URL"] = (
        "postgresql+psycopg://"
        f"{dbs['user']}:{dbs['password']}@{dbs['host']}:{dbs['port']}/{dbs['db']}"
    )


# --- FIX (tests): dejar DATABASE_URL listo en import-time ---
_set_database_url_env()


@pytest.fixture(scope="session", autouse=True)
def _apply_migrations() -> None:
    dbs = _get_test_db_settings()
    host = dbs["host"]
    port = int(dbs["port"])

    _wait_for_tcp(host, port, timeout_s=25.0)

    # --- FIX (tests): limpiar cache de Settings antes de correr Alembic ---
    # Asi Alembic/env.py y el resto del servicio usan DATABASE_URL de tests.
    try:
        from app.core.config import get_settings

        get_settings.cache_clear()
    except Exception:
        pass

    subprocess.check_call(["poetry", "run", "alembic", "upgrade", "head"])


@pytest.fixture(autouse=True)
def _truncate_products_before_each_test() -> None:
    # --- FIX (tests): evitar 409 por datos residuales entre tests ---
    # Solo truncamos si la tabla existe (si no, no interrumpimos el suite).
    try:
        from sqlalchemy import text

        from app.core.db import get_engine

        engine = get_engine()
        with engine.begin() as conn:
            conn.execute(
                text(
                    "TRUNCATE TABLE products RESTART IDENTITY CASCADE;"
                )
            )
    except Exception:
        pass


@pytest.fixture()
def client():
    from fastapi.testclient import TestClient

    from app.main import app

    return TestClient(app)
