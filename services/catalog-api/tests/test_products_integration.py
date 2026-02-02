# services/catalog-api/tests/test_products_integration.py
# El servicio actualmente es read-only: POST /v1/products => 405.
# Si en el futuro habilitas escritura, activa RUN_WRITE_TESTS=1.
import os
import requests


def test_create_product_behavior_matches_mode(base_url: str):
    payload = {"sku": "SKU-100", "name": "Producto 100"}
    r = requests.post(f"{base_url}/v1/products", json=payload, timeout=10)

    if os.getenv("RUN_WRITE_TESTS", "0").strip() == "1":
        assert r.status_code == 201, r.text
    else:
        assert r.status_code == 405, r.text


def test_create_product_duplicate_sku_behavior_matches_mode(base_url: str):
    payload = {"sku": "SKU-200", "name": "Producto 200"}
    r1 = requests.post(f"{base_url}/v1/products", json=payload, timeout=10)
    r2 = requests.post(f"{base_url}/v1/products", json=payload, timeout=10)

    if os.getenv("RUN_WRITE_TESTS", "0").strip() == "1":
        assert r1.status_code == 201, r1.text
        assert r2.status_code == 409, r2.text
    else:
        assert r1.status_code == 405, r1.text
        assert r2.status_code == 405, r2.text
