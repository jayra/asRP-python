from __future__ import annotations

import time
from uuid import uuid4

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response

from app.core.logging import get_logger

logger = get_logger("catalog-api.request")


class RequestIdMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # CHANGE: usar X-Request-Id si llega desde el Gateway; si no, generar uno
        request_id = request.headers.get("x-request-id") or str(uuid4())
        request.state.request_id = request_id

        start = time.perf_counter()

        logger.info(
            "request start",
            extra={
                "requestId": request_id,
                "method": request.method,
                "path": request.url.path,
                "status": None,
                "durationMs": None,
            },
        )

        response: Response = await call_next(request)

        duration_ms = int((time.perf_counter() - start) * 1000)

        # CHANGE: devolver siempre el id al cliente (y que vuelva al Gateway)
        response.headers["X-Request-Id"] = request_id

        logger.info(
            "request end",
            extra={
                "requestId": request_id,
                "method": request.method,
                "path": request.url.path,
                "status": response.status_code,
                "durationMs": duration_ms,
            },
        )

        return response
