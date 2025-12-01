# 🔒 Solución para Error de PodSecurity

## ✅ Problema Identificado

El namespace `sn-labs-alrodrigo25` tiene **PodSecurity "restricted"** activado, que requiere:
- `allowPrivilegeEscalation: false`
- `capabilities.drop: ["ALL"]`
- `runAsNonRoot: true`
- `seccompProfile.type: RuntimeDefault`

## 🔧 Solución Implementada

He actualizado dos archivos:

### 1. `deployment.yaml` - Agregadas configuraciones de seguridad
### 2. `Dockerfile` - Agregado usuario no-root (appuser, UID 1000)

---

## 📋 Pasos para Actualizar en IBM Cloud

### Paso 1: Obtener los Cambios del Repositorio

```bash
cd /home/project/xrwvm-fullstack_developer_capstone
git pull origin main
```

**Salida esperada:**
```
From https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone
 * branch            main       -> FETCH_HEAD
Updating f2d3545..1aa7593
Fast-forward
 server/Dockerfile        | 7 +++++++
 server/deployment.yaml   | 16 ++++++++++++++++
 2 files changed, 22 insertions(+), 1 deletion(-)
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

### Paso 3: Reconstruir la Imagen Docker con el Usuario No-Root

```bash
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
echo "Namespace: $MY_NAMESPACE"

# Construir la nueva imagen
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .

# Subir al registry
docker push us.icr.io/$MY_NAMESPACE/dealership:latest
```

**Tiempo estimado:** 2-3 minutos

### Paso 4: Aplicar el Deployment Actualizado

```bash
export SN_ICR_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
envsubst < deployment.yaml | kubectl apply -f -
```

**Salida esperada:**
```
deployment.apps/dealership created
service/dealership created
```

### Paso 5: Verificar que el Pod Inicia Correctamente

```bash
# Ver el estado del deployment
kubectl get deployments

# Ver los pods (debe mostrar 1/1 READY)
kubectl get pods

# Ver los eventos (no debe haber errores)
kubectl get events --sort-by='.lastTimestamp' | tail -10
```

**Salida esperada:**
```
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
dealership   1/1     1            1           30s

NAME                          READY   STATUS    RESTARTS   AGE
dealership-xxxxxxxxxx-xxxxx   1/1     Running   0          30s
```

### Paso 6: Esperar a que el Pod Esté Listo

```bash
# Esperar hasta 5 minutos a que el pod esté listo
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s
```

**Salida esperada:**
```
pod/dealership-xxxxxxxxxx-xxxxx condition met
```

### Paso 7: Acceder a la Aplicación

```bash
kubectl port-forward deployment.apps/dealership 8000:8000
```

**Salida esperada:**
```
Forwarding from 127.0.0.1:8000 -> 8000
Forwarding from [::1]:8000 -> 8000
```

Luego usa el botón **"Launch Application"** con puerto **8000**.

---

## 🔍 Verificación de Logs

Si necesitas ver los logs del contenedor:

```bash
# Ver logs en tiempo real
kubectl logs -f deployment/dealership

# Ver logs detallados del pod
POD_NAME=$(kubectl get pods -l run=dealership -o jsonpath='{.items[0].metadata.name}')
kubectl logs $POD_NAME
```

**Logs esperados:**
```
Making migrations and migrating the database.
No changes detected
Operations to perform:
  Apply all migrations: admin, auth, contenttypes, djangoapp, sessions
Running migrations:
  No migrations to apply.
...
[INFO] Listening at: http://0.0.0.0:8000
[INFO] Using worker: sync
[INFO] Booting worker with pid: XXX
```

---

## 🎯 Cambios Realizados en los Archivos

### `deployment.yaml`

**Agregado a nivel de Pod:**
```yaml
spec:
  securityContext:
    runAsNonRoot: true
    runAsUser: 1000
    seccompProfile:
      type: RuntimeDefault
```

**Agregado a nivel de Container:**
```yaml
securityContext:
  allowPrivilegeEscalation: false
  runAsNonRoot: true
  runAsUser: 1000
  capabilities:
    drop:
    - ALL
  seccompProfile:
    type: RuntimeDefault
```

### `Dockerfile`

**Agregado:**
```dockerfile
# Create a non-root user
RUN groupadd -r appuser && useradd -r -g appuser -u 1000 appuser
# Set ownership of the app directory
RUN chown -R appuser:appuser $APP
# Make entrypoint executable
RUN chmod +x /app/entrypoint.sh
# Switch to non-root user
USER appuser
```

---

## ⚠️ Posibles Problemas y Soluciones

### Problema: "Permission denied" en entrypoint.sh

**Causa:** El archivo no tiene permisos de ejecución

**Solución:** Ya está resuelto con `RUN chmod +x /app/entrypoint.sh` antes de cambiar al usuario no-root

### Problema: "Permission denied" escribiendo en base de datos

**Causa:** El usuario appuser no tiene permisos para escribir db.sqlite3

**Solución:** El comando `RUN chown -R appuser:appuser $APP` da permisos completos al directorio

### Problema: El pod sigue sin iniciar

**Verificar:**
```bash
kubectl describe pod -l run=dealership
kubectl logs -l run=dealership
```

**Buscar:**
- Errores de permisos
- Errores de Python/Django
- Problemas de conectividad

---

## 📸 Siguiente Paso: Capturas de Pantalla

Una vez que el pod esté corriendo (1/1 READY), procede a tomar las capturas de pantalla:

1. `deployed_landingpage.png` - Página de inicio sin login
2. `deployed_loggedin.png` - Página de inicio autenticado
3. `deployed_dealer_detail.png` - Detalles del concesionario
4. `deployed_add_review.png` - Nueva reseña agregada

**Accede via:**
- Port-forward: `kubectl port-forward deployment.apps/dealership 8000:8000`
- Launch Application: Botón en Skills Network con puerto 8000

---

## ✅ Checklist de Verificación

- [ ] `git pull` ejecutado exitosamente
- [ ] Deployment anterior eliminado
- [ ] Nueva imagen Docker construida
- [ ] Imagen subida a Container Registry
- [ ] Deployment aplicado sin errores
- [ ] Pod en estado "Running" (1/1 READY)
- [ ] Port-forward funcionando
- [ ] Aplicación accesible en navegador
- [ ] Listo para tomar capturas de pantalla

---

## 🚀 Script Completo (Todo en uno)

```bash
#!/bin/bash
cd /home/project/xrwvm-fullstack_developer_capstone
echo "=== PASO 1: Obtener cambios del repositorio ==="
git pull origin main

echo -e "\n=== PASO 2: Eliminar deployment actual ==="
cd server
kubectl delete -f deployment.yaml

echo -e "\n=== PASO 3: Construir nueva imagen ==="
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .
docker push us.icr.io/$MY_NAMESPACE/dealership:latest

echo -e "\n=== PASO 4: Aplicar deployment actualizado ==="
export SN_ICR_NAMESPACE=$MY_NAMESPACE
envsubst < deployment.yaml | kubectl apply -f -

echo -e "\n=== PASO 5: Esperar a que el pod esté listo ==="
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s

echo -e "\n=== PASO 6: Verificar estado ==="
kubectl get deployments
kubectl get pods
kubectl get services

echo -e "\n=== ¡LISTO! Ahora ejecuta: ==="
echo "kubectl port-forward deployment.apps/dealership 8000:8000"
```

**Para ejecutar:**
```bash
chmod +x deploy_fixed.sh
./deploy_fixed.sh
```

---

**Commit actual:** `1aa7593` - "Agregar configuraciones de seguridad para PodSecurity restricted"
