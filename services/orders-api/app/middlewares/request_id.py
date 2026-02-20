from __future__ import annotations

from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import Response
from uuid import uuid4

from app.core.logging import logger


class RequestIdMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        request_id = request.headers.get("x-request-id") or str(uuid4())
        request.state.request_id = request_id

        # Log “start”
        logger.info(
            "request start",
            extra={"requestId": request_id},
        )

        response: Response = await call_next(request)
        response.headers["X-Request-Id"] = request_id

        # Log “end”
        logger.info(
            "request end",
            extra={"requestId": request_id},
        )

        return response
