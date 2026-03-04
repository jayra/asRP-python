# Runbook — Instalación K8s local (kind) + Backups (Keycloak/Docker)

## Alcance
Montaje reproducible en WSL-Ubuntu con Docker Desktop ya instalado:
- kind (Kubernetes IN Docker) + registry local
- ingress-nginx + cert-manager + metrics-server
- despliegue stack asRP (Keycloak + Gateway + catalog/orders + DBs + frontend)
- backups antes/durante/después (Keycloak + artefactos Docker/Compose/K8s)

---

## 0) Convenciones
- Ejecutar en WSL Ubuntu.
- Directorio repo: `~/work/asRP-python`
- Dominios:
  - Frontend: `https://app.localtest.me`
  - Gateway: `https://api.localtest.me`
  - Keycloak: `https://keycloak.localtest.me`
- TLS local: self-signed (el navegador puede mostrar “No seguro”).

---

## 1) Backups ANTES de prodlike (si vienes de un Keycloak previo)
> Objetivo: poder reconstruir realm/clients/roles/users.

### 1.1 Export realm Keycloak (desde el entorno donde viva Keycloak)
**Opción A — si Keycloak está en Docker Compose:**
```bash
cd ~/work/asRP-python
docker compose -p asrp exec -T keycloak /opt/keycloak/bin/kc.sh export --realm asrp --file /tmp/asrp-realm.json
docker compose -p asrp cp keycloak:/tmp/asrp-realm.json ./backups/asrp-realm-before-prodlike.json

Opción B — si Keycloak está en Kubernetes (K8s):
```bash
kubectl -n asrp exec deploy/keycloak -- /opt/keycloak/bin/kc.sh export --realm asrp --file /tmp/asrp-realm.json
kubectl -n asrp cp deploy/keycloak:/tmp/asrp-realm.json ./backups/asrp-realm-before-prodlike.json

Verificación:
```bash
ls -la ./backups/asrp-realm-before-prodlike.json

Nota enterprise: el export puede contener secretos (client secrets). No commitear.

---

## 2) Backups DEL entorno prodlike (Docker Compose)

### 2.1 Guardar configuración efectiva de Compose

```bash
cd ~/work/asRP-python
mkdir -p backups/prodlike
docker compose -p asrp config > backups/prodlike/compose.rendered.yml

### 2.2 Guardar lista de imágenes y tags usadas

```bash
docker images --format '{{.Repository}}:{{.Tag}}' | sort > backups/prodlike/docker-images.txt

### 2.3 Export realm desde prodlike (si aplica)

### 2.3 Export realm desde prodlike (si aplica)

Ahora realmente esta dentro de Kubernetes (K8s) y lo guardamos como:

backups/prodlike/asrp-realm-prodlike.json

```bash
mkdir -p backups/prodlike

KC_POD=$(kubectl -n asrp get pods -l app=keycloak -o jsonpath='{.items[0].metadata.name}')
echo "KC_POD=$KC_POD"

kubectl -n asrp exec "$KC_POD" -- sh -lc 'ls -la /tmp/asrp-realm-prodlike.json'
kubectl -n asrp exec "$KC_POD" -- sh -lc 'cat /tmp/asrp-realm-prodlike.json' > backups/prodlike/asrp-realm-prodlike.json

ls -la backups/prodlike/asrp-realm-prodlike.json
head -n 5 backups/prodlike/asrp-realm-prodlike.json

---

## 3) Instalación de tooling K8s (WSL)

### 3.1 kubectl (Kubernetes CLI)

```bash
cd ~
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key \
  | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" \
  | sudo tee /etc/apt/sources.list.d/kubernetes.list > /dev/null

sudo apt-get update
sudo apt-get install -y kubectl
kubectl version --client --output=yaml

### 3.2 kind

```bash
cd ~
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.23.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind version

### 3.3 Helm

```bash
cd ~
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version

### 3.4 Verificación Docker Desktop desde WSL

```bash
docker version
docker ps

---

## 4) Crear clúster kind + registry local

### 4.1 Registry local

```bash
docker run -d --restart=always -p 5001:5000 --name kind-registry registry:2 || true
curl -sS http://localhost:5001/v2/ || echo "REGISTRY_HTTP_FAIL"

### 4.2 Crear clúster

```bash
kind create cluster --config ~/work/asRP-python/k8s/cluster/kind-config.yaml
docker network connect kind kind-registry || true
kind get clusters
kubectl get nodes -o wide

---

## 5) Infra Helm: ingress-nginx + cert-manager + metrics-server

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add jetstack https://charts.jetstack.io
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update

helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set crds.enabled=true

helm upgrade --install metrics-server metrics-server/metrics-server \
  --namespace kube-system \
  --set args={--kubelet-insecure-tls}

Verificación:

```bash
kubectl -n ingress-nginx get pods
kubectl -n cert-manager get pods
kubectl -n kube-system get pods | grep metrics-server || true

---

## 6) TLS local (cert-manager self-signed)

```bash
cd ~/work/asRP-python
kubectl apply -f k8s/infra/cert-manager/cluster-issuer-selfsigned.yaml
kubectl apply -k k8s/apps/overlays/local
kubectl -n asrp get certificate
kubectl -n asrp get secret asrp-tls

---

## 7) Deploy stack asRP en K8s

### 7.1 Apply manifests

```bash
cd ~/work/asRP-python
kubectl apply -k k8s/apps/overlays/local
kubectl -n asrp get pods -o wide
kubectl -n asrp get ingress
kubectl -n asrp get svc

### 7.2 Verificación endpoints

```bash
curl -sk -o /dev/null -w "KEYCLOAK_OIDC=%{http_code}\n" https://keycloak.localtest.me/realms/asrp/.well-known/openid-configuration
curl -sk -o /dev/null -w "GATEWAY=%{http_code}\n"  https://api.localtest.me/health
curl -sk -o /dev/null -w "CATALOG=%{http_code}\n"  https://api.localtest.me/catalog/health
curl -sk -o /dev/null -w "ORDERS=%{http_code}\n"   https://api.localtest.me/orders/health
curl -sk -o /dev/null -w "FRONTEND=%{http_code}\n" https://app.localtest.me/

---

## 8) Backups DESPUÉS de K8s

### 8.1 Export realm desde Keycloak en K8s

```bash
cd ~/work/asRP-python
mkdir -p backups/k8s

kubectl -n asrp exec deploy/keycloak -- /opt/keycloak/bin/kc.sh export --realm asrp --file /tmp/asrp-realm.json
kubectl -n asrp cp deploy/keycloak:/tmp/asrp-realm.json backups/k8s/asrp-realm-k8s.json
ls -la backups/k8s/asrp-realm-k8s.json

### 8.2 Capturar estado del cluster (manifests efectivos)

```bash
kubectl -n asrp get all -o yaml > backups/k8s/asrp-all.yaml
kubectl -n asrp get networkpolicy -o yaml > backups/k8s/asrp-networkpolicy.yaml
kubectl -n asrp get hpa -o yaml > backups/k8s/asrp-hpa.yaml

---

## 9) Notas de seguridad (enterprise)

- No commitear exports de realm ni secretos (contienen client secrets).
- Mantener .secrets/ fuera de Git.
- Para versionar secretos cifrados: SOPS + age (checkpoint futuro).
