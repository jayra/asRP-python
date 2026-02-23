from __future__ import annotations

import logging
import sys
from typing import Any, Dict, Optional

from pythonjsonlogger import jsonlogger

from app.core.config import settings

# Logger de servicio
logger = logging.getLogger("orders-api")


class _SafeJsonFormatter(jsonlogger.JsonFormatter):
    """
    CHANGE (Observabilidad): JSON logger enterprise (python-json-logger)
    - No falla si faltan campos extra (requestId, method, path, status, durationMs)
    - Añade service/env para poder filtrar en agregadores de logs
    """

    DEFAULTS: Dict[str, Any] = {
        "requestId": None,
        "method": None,
        "path": None,
        "status": None,
        "durationMs": None,
        "service": "orders-api",
        "env": None,
    }

    def add_fields(self, log_record: Dict[str, Any], record: logging.LogRecord, message_dict: Dict[str, Any]) -> None:
        super().add_fields(log_record, record, message_dict)

        # CHANGE: defaults para evitar KeyError/format issues
        for k, v in self.DEFAULTS.items():
            log_record.setdefault(k, v)

        # CHANGE: si viene None, lo fijamos (setdefault no pisa None)
        if not log_record.get("service"):
            log_record["service"] = "orders-api"

        if not log_record.get("env"):
            # CHANGE: fallback robusto para env
            env = getattr(settings, "environment", None) or getattr(settings, "env", None) or "local"
            log_record["env"] = env

        # CHANGE: timestamp ISO (además de asctime si la lib lo añade)
        if "timestamp" not in log_record:
            log_record["timestamp"] = log_record.get("asctime")


def configure_logging() -> None:
    """
    CHANGE (Observabilidad):
    - Logs estructurados JSON (stdout), container-friendly
    - Evita duplicados si uvicorn recarga
    - Alinea uvicorn.* al mismo nivel
    """
    level_name = getattr(settings, "log_level", "INFO")
    level = getattr(logging, str(level_name).upper(), logging.INFO)

    root = logging.getLogger()
    root.setLevel(level)

    handler = logging.StreamHandler(sys.stdout)
    formatter = _SafeJsonFormatter(
        "%(asctime)s %(levelname)s %(name)s %(message)s "
        "%(requestId)s %(method)s %(path)s %(status)s %(durationMs)s %(service)s %(env)s"
    )
    handler.setFormatter(formatter)

    # CHANGE: Evita duplicados
    root.handlers = [handler]
    root.propagate = False

    # CHANGE: Uvicorn loggers alineados
    logging.getLogger("uvicorn").setLevel(level)
    logging.getLogger("uvicorn.error").setLevel(level)
    logging.getLogger("uvicorn.access").setLevel(level)

    logger.info("logging configured", extra={"requestId": None})


# CHANGE: helper (compatibilidad/estandarización con catalog-api)
def get_logger(name: Optional[str] = None) -> logging.Logger:
    return logging.getLogger(name or __name__)
