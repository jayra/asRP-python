# =========================
# deps: instala dependencias
# =========================
FROM node:20-alpine AS deps
WORKDIR /app

COPY package*.json ./
RUN npm ci


# =========================
# build: compila TypeScript
# =========================
FROM node:20-alpine AS build
WORKDIR /app

# Necesario para que npm pueda ejecutar scripts
COPY package*.json ./

COPY --from=deps /app/node_modules ./node_modules
COPY tsconfig.json ./
COPY src ./src

RUN npm run build


# =========================
# runtime: imagen final
# =========================
FROM node:20-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production

COPY package*.json ./
RUN npm ci --omit=dev

COPY --from=build /app/dist ./dist

EXPOSE 4000
CMD ["node", "dist/index.js"]
