# services/catalog-api/tests/test_health.py
# Tests de integración HTTP contra el contenedor (portfolio).
import requests


def test_health_ok(base_url: str):
    r = requests.get(f"{base_url}/health", timeout=10)
    assert r.status_code == 200, r.text

    data = r.json()
    assert data.get("status") == "ok"
    assert data.get("service") == "catalog-api"
    # No forzamos env/version aquí porque dependen del Settings interno y del despliegue.
