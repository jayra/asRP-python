import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";

// Proxy enterprise:
// - El navegador llama a /api/*
// - Vite reenvía a API Gateway (Express) en :4000
// - rewrite elimina /api para que el gateway reciba rutas reales (/health, /catalog/*, etc.)
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      "/api": {
        target: "http://localhost:4000", // [FIX] Gateway real (no Catalog-API :8002)
        changeOrigin: true,
        secure: false,
        rewrite: (path) => path.replace(/^\/api/, ""), // /api/catalog/... -> /catalog/...
      },
    },
  },
});
