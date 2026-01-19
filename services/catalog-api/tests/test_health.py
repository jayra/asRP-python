# tests/test_health.py

from __future__ import annotations

from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)


def test_health_ok():
    r = client.get("/health")
    assert r.status_code == 200

    data = r.json()
    assert data["status"] == "ok"
    assert data["service"] == "catalog-api"
    assert data["version"] == "0.1.0"

    # --- FIX (tests): en ejecución de tests el entorno correcto es "test" ---
    assert data["env"] == "test"
