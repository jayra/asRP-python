import os
import subprocess
import time
from typing import Optional

import pytest
import requests

# --- FIX (tests): defaults de entorno para que el suite sea estable ---
os.environ.setdefault("ENVIRONMENT", "test")
os.environ.setdefault("ENV", "test")
os.environ.setdefault("APP_ENV", "test")
os.environ.setdefault("LOG_LEVEL", "INFO")

# --- FIX (tests/CI): modo portfolio => no DB tests/migrations ---
_RUN_DB_MIGRATIONS = os.getenv("RUN_DB_MIGRATIONS", "1").strip() != "0"


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


# --- FIX (tests): fixture base_url para tests HTTP (portfolio/CI) ---
@pytest.fixture(scope="session")
def base_url() -> str:
    """
    Base URL del servicio en modo HTTP (portfolio/CI).
    Por defecto, el workflow expone catalog-api en http://localhost:8002
    """
    url = os.getenv("CATALOG_BASE_URL", "http://localhost:8002").strip()
    return url.rstrip("/")


# --- FIX (tests): healthcheck para esperar servicio antes de tests HTTP ---
@pytest.fixture(scope="session", autouse=True)
def _wait_for_service_http(base_url: str) -> None:
    """
    En modo portfolio/CI los tests son HTTP contra el contenedor.
    Espera a /health para evitar flakiness.
    """
    if os.getenv("RUN_HTTP_WAIT", "1").strip() == "0":
        return

    deadline = time.time() + 60.0
    last: Optional[Exception] = None
    while time.time() < deadline:
        try:
            r = requests.get(f"{base_url}/health", timeout=3)
            if r.status_code == 200:
                return
        except Exception as e:  # noqa: BLE001
            last = e
        time.sleep(1.0)

    raise RuntimeError(f"catalog-api no responde en {base_url}/health. Ultimo error: {last}")


# --- FIX (tests/RBAC): fixtures de tokens (JWT - JSON Web Token) ---
def _read_env_token(*names: str) -> str:
    for n in names:
        v = os.getenv(n, "").strip()
        if v:
            return v
    return ""


@pytest.fixture(scope="session")
def reader_token() -> str:
    """
    Token con rol catalog_read (RBAC - Role-Based Access Control).
    Se espera que exista en ENV como READER_TOKEN (o alias).
    """
    tok = _read_env_token("READER_TOKEN", "CATALOG_READER_TOKEN")
    if not tok:
        # --- FIX (tests): si no hay token, no debe romper CI; se marca como skip ---
        pytest.skip(
            "reader_token no disponible. Ejecuta antes: "
            "source scripts/asrp-ready.sh catalog-api reader && "
            "luego lanza pytest en la MISMA terminal."
        )
    return tok


@pytest.fixture(scope="session")
def no_role_token() -> str:
    """
    Token válido (OIDC - OpenID Connect) pero SIN rol catalog_read, para validar 403.
    Se espera en ENV como NO_ROLE_TOKEN (o alias).
    """
    tok = _read_env_token("NO_ROLE_TOKEN", "CATALOG_NO_ROLE_TOKEN", "NOROLE_TOKEN")
    if not tok:
        # --- FIX (tests): si no hay token, no debe romper CI; se marca como skip ---
        pytest.skip(
            "no_role_token no disponible. Provee un token de un usuario sin el rol "
            "catalog_read (por ejemplo exportando NO_ROLE_TOKEN=...)."
        )
    return tok


# =========================
# DB tests (opcional)
# =========================
def _get_test_db_settings() -> dict[str, str]:
    host = os.getenv("CATALOG_DB_HOST", "127.0.0.1")
    port = os.getenv("CATALOG_DB_PORT", "5434")
    db = os.getenv("CATALOG_DB_NAME", "catalog_test_db")
    user = os.getenv("CATALOG_DB_USER", "catalog_test_app")
    password = os.getenv("CATALOG_DB_PASSWORD", "catalog_test_app_pwd")

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

    return {"host": host, "port": port, "db": db, "user": user, "password": password}


def _set_database_url_env() -> None:
    dbs = _get_test_db_settings()
    os.environ["DATABASE_URL"] = (
        "postgresql+psycopg://"
        f"{dbs['user']}:{dbs['password']}@{dbs['host']}:{dbs['port']}/{dbs['db']}"
    )


if _RUN_DB_MIGRATIONS:
    os.environ.setdefault("CATALOG_DB_HOST", "127.0.0.1")
    os.environ.setdefault("CATALOG_DB_PORT", "5434")
    os.environ.setdefault("CATALOG_DB_NAME", "catalog_test_db")
    os.environ.setdefault("CATALOG_DB_USER", "catalog_test_app")
    os.environ.setdefault("CATALOG_DB_PASSWORD", "catalog_test_app_pwd")
    _set_database_url_env()


@pytest.fixture(scope="session", autouse=True)
def _apply_migrations() -> None:
    if not _RUN_DB_MIGRATIONS:
        return

    dbs = _get_test_db_settings()
    host = dbs["host"]
    port = int(dbs["port"])

    _wait_for_tcp(host, port, timeout_s=25.0)

    # --- FIX (tests): limpiar cache de Settings antes de correr Alembic (migrations) ---
    try:
        from app.core.config import get_settings

        get_settings.cache_clear()
    except Exception:
        pass

    subprocess.check_call(["poetry", "run", "alembic", "upgrade", "head"])
