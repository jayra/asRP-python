from fastapi.testclient import TestClient

from app.main import app

client = TestClient(app)

def test_ping_ok():
    r = client.get("/v1/ping")
    assert r.status_code == 200
    data = r.json()
    assert data["message"] == "pong"
    assert data["service"] == "identity-api"
