# Observabilidad: Logging estructurado (JSON)

## Objetivo
Estandarizar logs en formato **JSON** para poder:
- buscar/incidir por `requestId` (Correlation ID),
- crear dashboards/alertas en el futuro,
- depurar incidencias en producción sin acceso directo a la máquina.

## Principios (enterprise)
1. **JSON a stdout**: cada contenedor escribe logs a stdout en JSON (Docker/Kubernetes los recolectan).
2. **Campos estables**: mismo “schema” en Gateway y APIs.
3. **No secretos**: nunca loguear `Authorization`, tokens, passwords, client secrets.
4. **Correlación**: siempre incluir `requestId` (valor de `X-Request-Id`).

## Schema mínimo (campos obligatorios)
- `timestamp`: fecha/hora ISO8601 (UTC recomendado)
- `level`: INFO/WARN/ERROR
- `service`: nombre del servicio (api-gateway, catalog-api, orders-api)
- `env`: entorno (local/dev/stage/prod)
- `requestId`: correlation id (`X-Request-Id`)
- `message`: mensaje corto
- `method`: HTTP method (GET/POST/...)
- `path`: ruta (sin query si es posible)
- `status`: HTTP status code
- `durationMs`: duración de request

## Campos opcionales recomendados
- `remoteIp`: IP del cliente (ojo a `trust proxy`)
- `userAgent`
- `issuer`, `audience` (solo en logs de arranque/config, nunca en cada request)
- `upstream`: destino del proxy (gateway)
- `error`: objeto con `type`, `message` (sin datos sensibles)

## Implementación actual
### API Gateway (Express)
- Emite logs del servidor en JSON.
- Emite logs por request con `requestId`, `status`, `durationMs`.

### catalog-api (FastAPI)
- Logging JSON con `python-json-logger`.
- Middleware `RequestIdMiddleware`:
  - usa `X-Request-Id` si llega,
  - si no llega, genera uno,
  - lo devuelve en `X-Request-Id`,
  - loguea `request start/end` con duración.

### orders-api (FastAPI)
- Logging JSON.
- Middleware `RequestIdMiddleware` alineado con catalog:
  - `request start/end` con `method`, `path`, `status`, `durationMs`.

## Anti-patrones a evitar
- Loguear tokens completos o headers Authorization.
- Logs “texto libre” sin campos (dificulta observabilidad).
- Diferentes formatos JSON por servicio sin schema común.
