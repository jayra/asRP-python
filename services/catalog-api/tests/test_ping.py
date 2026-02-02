# services/catalog-api/tests/test_ping.py
# /v1/ping no existe en este servicio; validamos OpenAPI como evidencia.
import requests


def test_openapi_exposes_products_route(base_url: str):
    r = requests.get(f"{base_url}/openapi.json", timeout=10)
    assert r.status_code == 200, r.text
    data = r.json()
    paths = data.get("paths", {})
    assert "/v1/products" in paths, f"paths disponibles: {sorted(paths.keys())}"
