# RBAC (Role-Based Access Control)

## Principio
- Las APIs aplican autorización por roles del JWT (JSON Web Token), típicamente en:
  - `resource_access.<client_id>.roles`

## Catalog API
- Client id de RBAC: `asrp-catalog`
- Roles:
  - `catalog_read`
  - `catalog_write`
- Ejemplo:
  - GET de lectura requiere `catalog_read`
  - endpoints de escritura requieren `catalog_write`

## Orders API
- Client id de RBAC: `asrp-orders`
- Roles:
  - `orders_read`
  - `orders_write`
- Ejemplo:
  - `GET /v1/orders` requiere `orders_read`

## Códigos esperados
- 200 OK: rol permitido
- 403 Forbidden: token válido pero rol insuficiente
- 401 Unauthorized: falta token o token inválido (firma/issuer/audience)
