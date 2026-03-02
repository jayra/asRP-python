# checkpoint-p5-k8s-local-enterprise

## Objetivo
Migrar el stack prodlike de Docker Compose a Kubernetes (K8s: Kubernetes) local (kind: Kubernetes IN Docker) con enfoque enterprise:
- Ingress NGINX (controlador de entrada) + TLS (Transport Layer Security) con cert-manager
- Keycloak (OIDC: OpenID Connect) con realm `asrp`
- Frontend (Vite + React) servido por NGINX unprivileged
- API Gateway (Express) con validación JWT (JSON Web Token) + RBAC (Role-Based Access Control)
- Microservicios: catalog-api y orders-api (FastAPI) con BBDD (Base de Datos) Postgres independientes
- Hardening: NetworkPolicy (Kubernetes NetworkPolicy) + HPA (Horizontal Pod Autoscaler)

## URLs
- Frontend: https://app.localtest.me
- API Gateway: https://api.localtest.me
- Keycloak: https://keycloak.localtest.me

> TLS es self-signed en local: el navegador puede marcar “No seguro”.

---

## 1) Prerrequisitos (WSL)
Instalar:
- kubectl (Kubernetes CLI)
- kind (Kubernetes IN Docker)
- helm (Kubernetes Package Manager)
- Docker Desktop activo + integración WSL

Verificar:
```bash
kubectl version --client
kind version
helm version
docker version
docker ps
