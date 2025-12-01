# 🔧 Solución para Error: TemplateDoesNotExist index.html

## 🐛 Problema Identificado

Django muestra el error `TemplateDoesNotExist at /login/` porque:
- El frontend de React **no está construido** dentro del contenedor Docker
- Django busca `index.html` pero no encuentra el directorio `frontend/build/`

## ✅ Solución Implementada

He actualizado el `Dockerfile` para usar **multi-stage build**:
1. **Stage 1:** Construye el frontend de React con Node.js
2. **Stage 2:** Copia el build de React al contenedor Python/Django

---

## 📋 Pasos para Solucionar (Ejecutar en IBM Cloud)

### Paso 1: Obtener los Cambios Actualizados

```bash
cd /home/project/xrwvm-fullstack_developer_capstone
git pull origin main
```

**Salida esperada:**
```
From https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone
 * branch            main       -> FETCH_HEAD
Updating bcbd5ff..0584a4a
Fast-forward
 server/Dockerfile | 11 +++++++++++
 1 file changed, 11 insertions(+)
```

### Paso 2: Eliminar el Deployment Actual

```bash
cd server
kubectl delete -f deployment.yaml
```

**Salida esperada:**
```
deployment.apps "dealership" deleted
service "dealership" deleted
```

### Paso 3: Reconstruir la Imagen con el Frontend Incluido

```bash
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
echo "Construyendo imagen con frontend React..."
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .
```

**Tiempo estimado:** 3-5 minutos (construye Node.js + React + Python)

**Salida esperada:**
```
[+] Building 180.2s (17/17) FINISHED
 => [frontend-build 1/6] FROM docker.io/library/node:18-slim
 => [frontend-build 2/6] WORKDIR /frontend
 => [frontend-build 3/6] COPY frontend/package*.json ./
 => [frontend-build 4/6] RUN npm install
 => [frontend-build 5/6] COPY frontend/ ./
 => [frontend-build 6/6] RUN npm run build
 => [stage-1 1/9] FROM docker.io/library/python:3.12.0-slim-bookworm
 ...
 => [stage-1 8/9] COPY --from=frontend-build /frontend/build /app/frontend/build
Successfully built
Successfully tagged us.icr.io/sn-labs-xxxxx/dealership:latest
```

### Paso 4: Subir la Nueva Imagen

```bash
docker push us.icr.io/$MY_NAMESPACE/dealership:latest
```

**Tiempo estimado:** 1-2 minutos

### Paso 5: Aplicar el Deployment

```bash
export SN_ICR_NAMESPACE=$MY_NAMESPACE
envsubst < deployment.yaml | kubectl apply -f -
```

**Salida esperada:**
```
deployment.apps/dealership created
service/dealership created
```

### Paso 6: Esperar a que el Pod Esté Listo

```bash
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s
```

**Salida esperada:**
```
pod/dealership-xxxxxxxxxx-xxxxx condition met
```

### Paso 7: Verificar el Estado

```bash
kubectl get pods
kubectl get deployments
```

**Salida esperada:**
```
NAME                          READY   STATUS    RESTARTS   AGE
dealership-xxxxxxxxxx-xxxxx   1/1     Running   0          1m

NAME         READY   UP-TO-DATE   AVAILABLE   AGE
dealership   1/1     1            1           1m
```

### Paso 8: Ver los Logs para Confirmar

```bash
kubectl logs -l run=dealership
```

**Buscar estas líneas (sin errores):**
```
Making migrations and migrating the database.
No changes detected
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, djangoapp, sessions
Running migrations:
  No migrations to apply.

121 static files copied to '/app/static'.

[INFO] Starting gunicorn 23.0.0
[INFO] Listening at: http://0.0.0.0:8000
[INFO] Using worker: sync
[INFO] Booting worker with pid: XX
```

### Paso 9: Acceder a la Aplicación

```bash
kubectl port-forward deployment.apps/dealership 8000:8000
```

Luego usa el botón **"Launch Application"** con puerto **8000**.

---

## 🎯 Verificación de la Solución

### 1. Verificar que el Frontend Existe en el Contenedor

```bash
# Obtener el nombre del pod
POD_NAME=$(kubectl get pods -l run=dealership -o jsonpath='{.items[0].metadata.name}')

# Verificar que el directorio build existe
kubectl exec $POD_NAME -- ls -la /app/frontend/build/

# Verificar que index.html existe
kubectl exec $POD_NAME -- ls -la /app/frontend/build/index.html
```

**Salida esperada:**
```
total 12
drwxr-xr-x 4 appuser appuser 4096 Dec  1 15:00 .
drwxr-xr-x 5 appuser appuser 4096 Dec  1 15:00 ..
-rw-r--r-- 1 appuser appuser 3870 Dec  1 15:00 index.html
drwxr-xr-x 2 appuser appuser 4096 Dec  1 15:00 static
...
```

### 2. Probar las URLs

Una vez que la aplicación esté corriendo:

- **Página principal:** https://[tu-url]:8000/
- **Login:** https://[tu-url]:8000/login/
- **Dealers:** https://[tu-url]:8000/dealers/

Todas deben cargar sin el error `TemplateDoesNotExist`.

---

## 📸 Capturas de Pantalla

Ahora sí puedes tomar las 4 capturas requeridas:

### 1. `deployed_landingpage.png`
- URL: https://[tu-url]:8000/
- Sin autenticar
- Header con "Login" y "Register"

### 2. `deployed_loggedin.png`
- URL: https://[tu-url]:8000/
- Autenticado (login con root/root)
- Header con nombre de usuario y "Logout"

### 3. `deployed_dealer_detail.png`
- URL: https://[tu-url]:8000/dealer/[ID]
- Detalles del concesionario
- Reseñas con sentimientos

### 4. `deployed_add_review.png`
- URL: https://[tu-url]:8000/dealer/[ID]
- Después de agregar una reseña
- Nueva reseña visible con sentimiento

---

## 🔍 Cambios en el Dockerfile

### Antes:
```dockerfile
FROM python:3.12.0-slim-bookworm
# ... solo Python/Django
COPY . $APP
# Sin frontend build
```

### Después:
```dockerfile
# Stage 1: Build React frontend
FROM node:18-slim AS frontend-build
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm install
COPY frontend/ ./
RUN npm run build

# Stage 2: Python backend with built frontend
FROM python:3.12.0-slim-bookworm
# ...
COPY . $APP
# Copiar el build de React del stage 1
COPY --from=frontend-build /frontend/build $APP/frontend/build
```

---

## 🚨 Troubleshooting

### Problema: "npm install" falla en el build

**Causa:** Problemas con package.json o dependencias

**Solución:**
```bash
# Verificar que frontend/package.json existe
ls -la /home/project/xrwvm-fullstack_developer_capstone/server/frontend/package.json

# Si es necesario, limpiar node_modules local
rm -rf frontend/node_modules
```

### Problema: "frontend/build" no se copia

**Causa:** El build de React falló en el stage 1

**Solución:**
```bash
# Ver logs detallados del build
docker build --progress=plain -t us.icr.io/$MY_NAMESPACE/dealership:latest .

# Buscar errores en la sección "frontend-build"
```

### Problema: collectstatic falla

**Causa:** Permisos o configuración de STATICFILES_DIRS

**Verificar:**
```bash
# Ver los logs del pod
kubectl logs -l run=dealership

# Buscar líneas como:
# "121 static files copied to '/app/static'."
```

### Problema: Página carga pero sin estilos

**Causa:** Archivos estáticos no se sirvieron correctamente

**Solución:**
```bash
# Verificar que collectstatic ejecutó
kubectl logs -l run=dealership | grep "static files copied"

# Verificar el directorio static
POD_NAME=$(kubectl get pods -l run=dealership -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD_NAME -- ls -la /app/static/
```

---

## ✅ Checklist de Verificación

- [ ] `git pull` ejecutado (commit 0584a4a)
- [ ] Deployment anterior eliminado
- [ ] Nueva imagen construida (con Node.js stage)
- [ ] Build de React completado sin errores
- [ ] Imagen subida a Container Registry
- [ ] Deployment aplicado
- [ ] Pod en estado "Running" (1/1 READY)
- [ ] Logs muestran "static files copied"
- [ ] URL principal carga sin errores
- [ ] URL /login/ carga sin errores
- [ ] Frontend React funcional
- [ ] Listo para capturas de pantalla

---

## 🚀 Script Completo Todo-en-Uno

```bash
#!/bin/bash
cd /home/project/xrwvm-fullstack_developer_capstone

echo "=== PASO 1: Actualizar repositorio ==="
git pull origin main

echo -e "\n=== PASO 2: Eliminar deployment anterior ==="
cd server
kubectl delete -f deployment.yaml

echo -e "\n=== PASO 3: Construir imagen con React frontend ==="
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .

echo -e "\n=== PASO 4: Subir imagen ==="
docker push us.icr.io/$MY_NAMESPACE/dealership:latest

echo -e "\n=== PASO 5: Aplicar deployment ==="
export SN_ICR_NAMESPACE=$MY_NAMESPACE
envsubst < deployment.yaml | kubectl apply -f -

echo -e "\n=== PASO 6: Esperar a que el pod esté listo ==="
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s

echo -e "\n=== PASO 7: Verificar ==="
kubectl get pods
kubectl get deployments

echo -e "\n=== PASO 8: Ver logs ==="
kubectl logs -l run=dealership | tail -20

echo -e "\n=== ¡LISTO! ==="
echo "Ejecuta: kubectl port-forward deployment.apps/dealership 8000:8000"
echo "Luego usa Launch Application con puerto 8000"
```

---

**Commit actual:** `0584a4a` - "Agregar build multi-stage de React frontend en Dockerfile"

**Próximo paso:** Ejecuta los comandos en IBM Cloud Terminal para reconstruir la imagen con el frontend incluido. 🚀
