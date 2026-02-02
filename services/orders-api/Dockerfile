# syntax=docker/dockerfile:1

FROM python:3.11-slim

# [SECURITY] No corremos como root en runtime
RUN useradd -m appuser

WORKDIR /app

# Instalación de Poetry (dependencias)
RUN pip install --no-cache-dir poetry==1.8.3

COPY pyproject.toml /app/
# (poetry.lock se generará cuando avances; si existe, cópialo también)
RUN poetry config virtualenvs.create false \
  && poetry install --only main --no-interaction --no-ansi

COPY app /app/app

USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
