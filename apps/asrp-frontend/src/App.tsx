import React, { useEffect, useMemo, useState } from "react";
import { User, UserManager, WebStorageStateStore, Log } from "oidc-client-ts";

const OIDC_AUTHORITY = import.meta.env.VITE_OIDC_AUTHORITY as string;
const OIDC_CLIENT_ID = import.meta.env.VITE_OIDC_CLIENT_ID as string;
const OIDC_REDIRECT_URI = import.meta.env.VITE_OIDC_REDIRECT_URI as string;
const OIDC_POST_LOGOUT_REDIRECT_URI = import.meta.env.VITE_OIDC_POST_LOGOUT_REDIRECT_URI as string;
const DEBUG_AUTH = (import.meta.env.VITE_DEBUG_AUTH as string) === "true";

function decodeJwtPayload(token: string): any | null {
  try {
    const parts = token.split(".");
    if (parts.length < 2) return null;
    const payload = parts[1];
    const padded = payload + "=".repeat((4 - (payload.length % 4)) % 4);
    const json = atob(padded.replace(/-/g, "+").replace(/_/g, "/"));
    return JSON.parse(json);
  } catch {
    return null;
  }
}

function getClientRoles(payload: any, clientId: string): string[] {
  const roles = payload?.resource_access?.[clientId]?.roles;
  return Array.isArray(roles) ? roles : [];
}

const userManager = new UserManager({
  authority: OIDC_AUTHORITY,
  client_id: OIDC_CLIENT_ID,
  redirect_uri: OIDC_REDIRECT_URI,
  post_logout_redirect_uri: OIDC_POST_LOGOUT_REDIRECT_URI,
  response_type: "code",
  scope: "openid profile email",
  userStore: new WebStorageStateStore({ store: window.localStorage }),
  loadUserInfo: false,
  automaticSilentRenew: false,
});

Log.setLogger(console);
Log.setLevel(Log.NONE);

type ApiState =
  | { kind: "idle" }
  | { kind: "loading" }
  | { kind: "success"; status: number; body: unknown }
  | { kind: "error"; status?: number; message: string };

export default function App() {
  const [user, setUser] = useState<User | null>(null);
  const [oidcError, setOidcError] = useState<string | null>(null);

  // [FIX] Estados separados para evitar mezclar respuestas de endpoints distintos (Catalog vs Orders)
  const [apiCatalogState, setApiCatalogState] = useState<ApiState>({ kind: "idle" });
  const [apiOrdersState, setApiOrdersState] = useState<ApiState>({ kind: "idle" });

  useEffect(() => {
    let cancelled = false;

    // [FIX] Eventos para refrescar UI sin F5 cuando se carga/descarga usuario
    const onUserLoaded = (u: User) => !cancelled && setUser(u);
    const onUserUnloaded = () => !cancelled && setUser(null);
    userManager.events.addUserLoaded(onUserLoaded);
    userManager.events.addUserUnloaded(onUserUnloaded);

    const run = async () => {
      try {
        const url = new URL(window.location.href);
        const code = url.searchParams.get("code");
        const state = url.searchParams.get("state");
        const hasAuthCode = !!code && !!state;

        // [FIX] Guard anti “code already used / code not valid”
        // En dev puede ejecutarse el callback más de una vez.
        const cbKey = state ? `oidc_cb_done:${state}` : null;
        const alreadyHandled = cbKey ? sessionStorage.getItem(cbKey) === "1" : false;

        if (hasAuthCode && !alreadyHandled) {
          if (cbKey) sessionStorage.setItem(cbKey, "1");
          await userManager.signinRedirectCallback();

          // Limpia la URL para no reusar el code en refresh/back
          window.history.replaceState({}, document.title, url.origin + url.pathname);
        }

        const currentUser = await userManager.getUser();
        if (!cancelled) setUser(currentUser);
        if (!cancelled) setOidcError(null);
      } catch (e: any) {
        console.error("OIDC error:", e);
        if (!cancelled) {
          setOidcError(e?.message || "OIDC error");
          setUser(null);

          // [FIX] Si el callback falla, limpia la URL igualmente para no quedar “atascado”
          const clean = new URL(window.location.href);
          window.history.replaceState({}, document.title, clean.origin + clean.pathname);
        }
      }
    };

    run();

    return () => {
      cancelled = true;
      userManager.events.removeUserLoaded(onUserLoaded);
      userManager.events.removeUserUnloaded(onUserUnloaded);
    };
  }, []);

  const accessToken = user?.access_token ?? "";
  const tokenPayload = useMemo(() => (accessToken ? decodeJwtPayload(accessToken) : null), [accessToken]);

  // [FIX] Roles por cliente (Keycloak): Catalog y Orders
  const catalogRoles = useMemo(
    () => (tokenPayload ? getClientRoles(tokenPayload, "asrp-catalog") : []),
    [tokenPayload]
  );
  const ordersRoles = useMemo(
    () => (tokenPayload ? getClientRoles(tokenPayload, "asrp-orders") : []),
    [tokenPayload]
  );

  const canReadCatalog = catalogRoles.includes("catalog_read");
  // [FIX] Para Orders, permitir GET si el usuario tiene orders_read o orders_write (writer ⊇ read en la práctica)
  const canReadOrders = ordersRoles.includes("orders_read") || ordersRoles.includes("orders_write");

  const isAuthenticated = !!user && !user.expired && !!accessToken;

  const login = async () => {
    setOidcError(null);
    await userManager.signinRedirect();
  };

  const logout = async () => {
    setOidcError(null);
    await userManager.signoutRedirect();
  };

  const callCatalogProducts = async () => {
    if (!isAuthenticated) {
      setApiCatalogState({ kind: "error", message: "Not authenticated." });
      return;
    }
    setApiCatalogState({ kind: "loading" });

    try {
      // Ruta correcta: /api -> Vite proxy -> Gateway -> /catalog/...
      const resp = await fetch("/api/catalog/v1/products", {
        method: "GET",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          Accept: "application/json",
        },
      });

      const status = resp.status;
      const contentType = resp.headers.get("content-type") || "";
      const body = contentType.includes("application/json") ? await resp.json() : await resp.text();

      if (!resp.ok) {
        setApiCatalogState({
          kind: "error",
          status,
          message: typeof body === "string" ? body : JSON.stringify(body, null, 2),
        });
        return;
      }

      setApiCatalogState({ kind: "success", status, body });
    } catch (e: any) {
      setApiCatalogState({ kind: "error", message: e?.message || "Fetch failed" });
    }
  };

  const callOrders = async () => {
    if (!isAuthenticated) {
      setApiOrdersState({ kind: "error", message: "Not authenticated." });
      return;
    }
    setApiOrdersState({ kind: "loading" });

    try {
      // [FIX] Orders: /api -> Vite proxy -> Gateway -> /orders/...
      const resp = await fetch("/api/orders/v1/orders", {
        method: "GET",
        headers: {
          Authorization: `Bearer ${accessToken}`,
          Accept: "application/json",
        },
      });

      const status = resp.status;
      const contentType = resp.headers.get("content-type") || "";
      const body = contentType.includes("application/json") ? await resp.json() : await resp.text();

      if (!resp.ok) {
        setApiOrdersState({
          kind: "error",
          status,
          message: typeof body === "string" ? body : JSON.stringify(body, null, 2),
        });
        return;
      }

      setApiOrdersState({ kind: "success", status, body });
    } catch (e: any) {
      setApiOrdersState({ kind: "error", message: e?.message || "Fetch failed" });
    }
  };

  return (
    <div style={{ maxWidth: 980, margin: "48px auto", padding: "0 16px" }}>
      <h1 style={{ marginBottom: 6 }}>asrp-frontend</h1>
      <p style={{ marginTop: 0, color: "#555" }}>
        OIDC (OpenID Connect) Authorization Code + PKCE (Proof Key for Code Exchange) — API via <code>/api</code>
      </p>

      {oidcError && (
        <div
          style={{
            border: "1px solid #f2caca",
            background: "#fff6f6",
            borderRadius: 10,
            padding: 16,
            marginBottom: 16,
          }}
        >
          <b>OIDC error</b>
          <div style={{ marginTop: 6, whiteSpace: "pre-wrap" }}>{oidcError}</div>
        </div>
      )}

      <div style={{ display: "flex", gap: 12, alignItems: "center", margin: "16px 0", flexWrap: "wrap" }}>
        {!isAuthenticated ? <button onClick={login}>Login</button> : <button onClick={logout}>Logout</button>}

        <button
          onClick={callCatalogProducts}
          disabled={!isAuthenticated || !canReadCatalog || apiCatalogState.kind === "loading"}
        >
          {apiCatalogState.kind === "loading" ? "Loading…" : "GET /catalog/v1/products"}
        </button>

        {/* [FIX] Nuevo bloque Orders (sin tocar login): mismo token + proxy /api */}
        <button onClick={callOrders} disabled={!isAuthenticated || !canReadOrders || apiOrdersState.kind === "loading"}>
          {apiOrdersState.kind === "loading" ? "Loading…" : "GET /orders/v1/orders"}
        </button>

        <span style={{ marginLeft: "auto", fontSize: 12, color: "#666" }}>
          Gateway: <code>http://localhost:4000</code> — Upstreams via proxy
        </span>
      </div>

      <div style={{ border: "1px solid #e5e5e5", borderRadius: 10, padding: 16, marginBottom: 16 }}>
        <h3 style={{ marginTop: 0 }}>Auth status</h3>
        <div style={{ display: "grid", gap: 6 }}>
          <div>
            <b>Authenticated:</b> {String(isAuthenticated)}
          </div>
          <div>
            <b>User:</b> {tokenPayload?.preferred_username || user?.profile?.preferred_username || "-"}
          </div>

          <div>
            <b>Roles (asrp-catalog):</b> {catalogRoles.length ? catalogRoles.join(", ") : "-"}
          </div>
          <div>
            <b>Has role catalog_read:</b> {String(canReadCatalog)}
          </div>

          {/* [FIX] Orders roles visible para depurar RBAC (Role-Based Access Control) */}
          <div style={{ marginTop: 8 }}>
            <b>Roles (asrp-orders):</b> {ordersRoles.length ? ordersRoles.join(", ") : "-"}
          </div>
          <div>
            <b>Has role orders_read / orders_write:</b> {String(canReadOrders)}
          </div>
        </div>
      </div>

      {DEBUG_AUTH && (
        <div style={{ border: "1px solid #e5e5e5", borderRadius: 10, padding: 16, marginBottom: 16 }}>
          <h3 style={{ marginTop: 0 }}>Token claims (debug)</h3>
          <pre style={{ whiteSpace: "pre-wrap", margin: 0 }}>{JSON.stringify(tokenPayload, null, 2)}</pre>
        </div>
      )}

      <div style={{ display: "grid", gap: 16 }}>
        <div style={{ border: "1px solid #e5e5e5", borderRadius: 10, padding: 16 }}>
          <h3 style={{ marginTop: 0 }}>Catalog API response</h3>
          {apiCatalogState.kind === "idle" && (
            <p style={{ color: "#666" }}>Pulsa el botón para llamar vía /api → Gateway → /catalog.</p>
          )}
          {apiCatalogState.kind === "loading" && <p>Loading…</p>}
          {apiCatalogState.kind === "error" && (
            <>
              <div>
                <b>Status:</b> {apiCatalogState.status ?? "-"}
              </div>
              <pre style={{ whiteSpace: "pre-wrap" }}>{apiCatalogState.message}</pre>
            </>
          )}
          {apiCatalogState.kind === "success" && (
            <>
              <div style={{ marginBottom: 8 }}>
                <b>Status:</b> {apiCatalogState.status}
              </div>
              <pre style={{ whiteSpace: "pre-wrap" }}>
                {typeof apiCatalogState.body === "string"
                  ? apiCatalogState.body
                  : JSON.stringify(apiCatalogState.body, null, 2)}
              </pre>
            </>
          )}
        </div>

        {/* [FIX] Orders: respuesta separada para evitar confusión visual */}
        <div style={{ border: "1px solid #e5e5e5", borderRadius: 10, padding: 16 }}>
          <h3 style={{ marginTop: 0 }}>Orders API response</h3>
          {apiOrdersState.kind === "idle" && (
            <p style={{ color: "#666" }}>Pulsa el botón para llamar vía /api → Gateway → /orders.</p>
          )}
          {apiOrdersState.kind === "loading" && <p>Loading…</p>}
          {apiOrdersState.kind === "error" && (
            <>
              <div>
                <b>Status:</b> {apiOrdersState.status ?? "-"}
              </div>
              <pre style={{ whiteSpace: "pre-wrap" }}>{apiOrdersState.message}</pre>
            </>
          )}
          {apiOrdersState.kind === "success" && (
            <>
              <div style={{ marginBottom: 8 }}>
                <b>Status:</b> {apiOrdersState.status}
              </div>
              <pre style={{ whiteSpace: "pre-wrap" }}>
                {typeof apiOrdersState.body === "string" ? apiOrdersState.body : JSON.stringify(apiOrdersState.body, null, 2)}
              </pre>
            </>
          )}
        </div>
      </div>
    </div>
  );
}
