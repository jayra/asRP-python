# Observabilidad: Correlation ID (X-Request-Id)

## ¿Qué es?
`X-Request-Id` es un identificador único por request que permite seguir una petición a través de:
**Frontend → API Gateway → Microservicios → Logs**.

## Por qué importa (enterprise)
- Depuración rápida: con un `requestId` encuentras todos los logs relacionados.
- Soporte/producción: reduces el tiempo de diagnóstico (MTTR: Mean Time To Recovery).

## Regla del proyecto (asRP-python)
1. Si el cliente envía `X-Request-Id`, **se respeta**.
2. Si no lo envía, el **Gateway lo genera**.
3. El Gateway lo **propaga** a los upstreams (catalog/orders).
4. Los microservicios lo devuelven en la respuesta (`X-Request-Id`).
5. Los logs siempre incluyen `requestId`.

## Pruebas rápidas (curl)
### Gateway health
```bash
curl -i -H "X-Request-Id: obs-gw-001" http://localhost:4000/health
