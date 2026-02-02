import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App";
import "./index.css";

// [FIX] Quitamos react-oidc-context para evitar “doble OIDC”.
//       App.tsx ya gestiona OIDC (OpenID Connect) con oidc-client-ts directamente.
//       Esto elimina el síntoma de “tengo que pulsar F5 tras volver del login”.

ReactDOM.createRoot(document.getElementById("root")!).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>
);
