# Runbook: depuración con logs + requestId (Correlation ID)

## Objetivo
Resolver incidencias típicas (401/403/502/500) usando:
- `X-Request-Id` para correlación end-to-end (Gateway → APIs)
- logs estructurados en JSON (API Gateway + catalog-api + orders-api)

## Reglas del proyecto
1) Si envías `X-Request-Id`, el Gateway lo **respeta** y lo **propaga** a los upstreams.  
2) Si no envías `X-Request-Id`, el Gateway genera uno y lo devuelve en la respuesta.  
3) Los microservicios devuelven `X-Request-Id` y loguean `request start/end` con duración (`durationMs`).  
4) Nunca se loguean tokens/secretos (no `Authorization`, no passwords, no client secrets).

---

## Paso 0 — Comprobar estado del stack
```bash
docker compose ps
