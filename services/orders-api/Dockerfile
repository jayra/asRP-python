# syntax=docker/dockerfile:1

FROM python:3.12-slim

WORKDIR /app

# [SECURITY] No cache + minimiza superficie
RUN pip install --no-cache-dir poetry

COPY pyproject.toml poetry.lock* README.md /app/
RUN poetry config virtualenvs.create false \
 && poetry install --no-interaction --no-ansi --only main --no-root

COPY app /app/app

EXPOSE 8000

# [ENTERPRISE] Health endpoint + logs a stdout
CMD ["uvicorn", "app.main:app", "--host=0.0.0.0", "--port=8000"]
