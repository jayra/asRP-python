import requests


def test_products_without_token_returns_401(base_url: str):
    r = requests.get(f"{base_url}/v1/products", timeout=10)
    assert r.status_code == 401, r.text


def test_products_with_reader_token_returns_200(base_url: str, reader_token: str):
    r = requests.get(
        f"{base_url}/v1/products",
        headers={"Authorization": f"Bearer {reader_token}"},
        timeout=10,
    )
    assert r.status_code == 200, r.text


def test_products_with_valid_token_without_role_returns_403(base_url: str, no_role_token: str):
    r = requests.get(
        f"{base_url}/v1/products",
        headers={"Authorization": f"Bearer {no_role_token}"},
        timeout=10,
    )
    assert r.status_code == 403, r.text
