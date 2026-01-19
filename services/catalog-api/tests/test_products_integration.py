def test_create_product_ok(client):
    r = client.post("/v1/products", json={"sku": "SKU-100", "name": "Producto 100"})
    assert r.status_code == 201
    data = r.json()
    assert data["sku"] == "SKU-100"
    assert data["name"] == "Producto 100"
    assert "id" in data


def test_create_product_duplicate_sku(client):
    client.post("/v1/products", json={"sku": "SKU-200", "name": "Producto 200"})
    r = client.post("/v1/products", json={"sku": "SKU-200", "name": "Producto 200 bis"})
    assert r.status_code == 409


def test_get_product_404(client):
    r = client.get("/v1/products/999999")
    assert r.status_code == 404
