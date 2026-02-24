# apps/asrp-frontend/Dockerfile
#
# [FIX] Prod-like: build Vite + React y servir con NGINX sin privilegios
# usando nginxinc/nginx-unprivileged (evita chown / permisos).
# Mantiene SPA routing + proxy /api -> api-gateway.

FROM node:20-alpine AS build

WORKDIR /app

ARG VITE_OIDC_ISSUER_URL
ARG VITE_API_BASE_URL
ENV VITE_OIDC_ISSUER_URL=${VITE_OIDC_ISSUER_URL}
ENV VITE_API_BASE_URL=${VITE_API_BASE_URL}

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# [FIX] Imagen NGINX unprivileged (no intenta chown y corre como usuario no-root)
FROM nginxinc/nginx-unprivileged:1.27-alpine

# [FIX] En esta imagen, el default conf suele estar en /etc/nginx/conf.d/
COPY nginx.conf /etc/nginx/conf.d/default.conf

# [FIX] Copiar el build estático a la ruta estándar
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 8080
