# Runbook: entorno local (Docker Compose)

## Arranque limpio (rebuild)
```bash
cd ~/work/asRP-python
docker compose up -d --build
docker compose ps
