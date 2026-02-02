# services/catalog-api/tests/test_routes.py
# Evitamos TestClient (depende de Settings local) y probamos contenedor real.
import requests


def test_health_ok(base_url: str):
    r = requests.get(f"{base_url}/health", timeout=10)
    assert r.status_code == 200, r.text


def test_products_requires_token(base_url: str):
    r = requests.get(f"{base_url}/v1/products", timeout=10)
    assert r.status_code == 401, r.text
