from fastapi import FastAPI

app = FastAPI(title="Identity API", version="0.1.0")


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/v1/ping")
def ping():
    return {"message": "pong"}

