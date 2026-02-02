from __future__ import annotations

import logging
import sys
from typing import Optional


def configure_logging(level: str = "INFO") -> None:
    """
    Configure Python standard logging once for the whole service.

    This is intentionally simple (stdout) and container-friendly.
    """
    root = logging.getLogger()
    if root.handlers:
        # Already configured (avoid duplicate handlers in reloads/tests).
        return

    numeric_level = getattr(logging, level.upper(), logging.INFO)
    logging.basicConfig(
        level=numeric_level,
        format="%(asctime)s %(levelname)s %(name)s - %(message)s",
        stream=sys.stdout,
    )


def get_logger(name: Optional[str] = None) -> logging.Logger:
    """
    Small helper used across the codebase to get a logger.

    Kept in app.core.logging so imports stay stable.
    """
    return logging.getLogger(name or __name__)
