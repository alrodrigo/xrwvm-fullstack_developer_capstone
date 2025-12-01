# Guía de Despliegue en Kubernetes - IBM Cloud

## Capturas de Pantalla Requeridas para la Aplicación Desplegada

Esta guía te ayudará a completar la sección final del proyecto tomando las capturas de pantalla requeridas de la aplicación desplegada en Kubernetes.

---

## Requisitos Previos

Antes de comenzar el despliegue, asegúrate de:

1. ✅ Estar conectado al clúster de Kubernetes de IBM Cloud
2. ✅ Tener IBM Cloud CLI instalado y configurado
3. ✅ Tener `kubectl` configurado y funcionando
4. ✅ Haber construido y subido la imagen Docker al Container Registry

---

## Paso 1: Verificar Prerrequisitos

```bash
# Verificar conexión a Kubernetes
kubectl cluster-info

# Verificar namespaces de Container Registry
ibmcloud cr namespaces
```

---

## Paso 2: Construir y Subir la Imagen Docker (si no lo has hecho)

```bash
# Navegar al directorio del servidor
cd server

# Obtener tu namespace
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
echo "Namespace: $MY_NAMESPACE"

# Construir la imagen
docker build -t us.icr.io/$MY_NAMESPACE/dealership .

# Subir la imagen al registro
docker push us.icr.io/$MY_NAMESPACE/dealership

# Verificar que la imagen se subió
ibmcloud cr images | grep dealership
```

---

## Paso 3: Desplegar en Kubernetes

```bash
# Exportar el namespace para usar en deployment.yaml
export SN_ICR_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)

# Aplicar el deployment con sustitución de variables
envsubst < deployment.yaml | kubectl apply -f -

# O usar el script automatizado
chmod +x deploy.sh
./deploy.sh
```

---

## Paso 4: Verificar el Despliegue

```bash
# Ver el estado del deployment
kubectl get deployments

# Ver los pods
kubectl get pods

# Ver los servicios
kubectl get services

# Ver logs del pod (si hay problemas)
kubectl logs -f deployment/dealership
```

**Salida esperada:**
```
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
dealership    1/1     1            1           1m

NAME                          READY   STATUS    RESTARTS   AGE
dealership-xxxxxxxxxx-xxxxx   1/1     Running   0          1m

NAME         TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
dealership   NodePort   10.xxx.xxx.xxx  <none>        8000:xxxxx/TCP   1m
```

---

## Paso 5: Acceder a la Aplicación

### Opción A: Port Forwarding (Recomendado para entorno de laboratorio)

```bash
# Reenviar el puerto 8000 del deployment a tu máquina local
kubectl port-forward deployment.apps/dealership 8000:8000
```

**Nota:** Si ves algún error, espera un momento y ejecuta el comando nuevamente.

### Opción B: Usar el Botón "Launch Application"

1. Haz clic en el botón **"Skills Network"** a la derecha
2. Abre la **"Skills Network Toolbox"**
3. Haz clic en **"OTHER"** → **"Launch Application"**
4. Ingresa el puerto **8000**
5. Haz clic en **"Launch"**

---

## Paso 6: Tomar las Capturas de Pantalla Requeridas

⚠️ **IMPORTANTE:** Asegúrate de que la barra de direcciones sea visible en TODAS las capturas de pantalla.

### 1. `deployed_landingpage.png`
- **Qué capturar:** Página de inicio con pantalla de inicio de sesión
- **Cómo:** Abre la URL del deployment en el navegador
- **URL:** `http://localhost:8000` o la URL del puerto mapeado
- **Contenido esperado:**
  - Header con botones "Login" y "Register"
  - Página principal de Dealership App
  - Barra de direcciones visible mostrando la URL del deployment

### 2. `deployed_loggedin.png`
- **Qué capturar:** Página de inicio después de iniciar sesión
- **Cómo:** 
  1. Haz clic en "Login"
  2. Ingresa credenciales (ejemplo: root/root o cualquier usuario creado)
  3. Una vez autenticado, captura la página principal
- **Contenido esperado:**
  - Header mostrando el nombre de usuario
  - Botón "Logout" visible
  - Página principal de Dealership App
  - Barra de direcciones visible

### 3. `deployed_dealer_detail.png`
- **Qué capturar:** Página de detalles del concesionario con reseñas
- **Cómo:**
  1. Estando autenticado, navega a "Dealers"
  2. Haz clic en cualquier concesionario
  3. Captura la página de detalles
- **URL esperada:** `http://localhost:8000/dealer/[ID]`
- **Contenido esperado:**
  - Información del concesionario
  - Lista de reseñas con sentimientos (positive/neutral/negative)
  - Botón "Post Review"
  - Barra de direcciones visible

### 4. `deployed_add_review.png`
- **Qué capturar:** Página de detalles después de agregar una reseña
- **Cómo:**
  1. Desde la página de detalles del concesionario, haz clic en "Post Review"
  2. Completa el formulario de reseña
  3. Envía la reseña
  4. Verifica que aparece en la página de detalles
  5. Captura la página mostrando la nueva reseña
- **Contenido esperado:**
  - Nueva reseña visible en la lista
  - Sentimiento de la reseña mostrado (positive/neutral/negative)
  - Nombre del autor de la reseña
  - Barra de direcciones visible

---

## Verificación de URL

**ANTES de tomar las capturas de pantalla:**

1. Copia la URL completa de la barra de direcciones
2. Verifica que es la misma URL en TODAS las capturas
3. Asegúrate de que la URL sea visible en cada captura

**Ejemplos de URL válidas:**
- `http://localhost:8000/dealers`
- `http://proxy-xxxxx.skilsnetwork.site:8000/dealer/29`
- `http://sn-labs-xxxxx.sn.labs/postreview/15`

---

## Comandos Útiles de Troubleshooting

### Ver logs del contenedor:
```bash
kubectl logs -f deployment/dealership
```

### Reiniciar el deployment:
```bash
kubectl rollout restart deployment/dealership
```

### Verificar el estado detallado del pod:
```bash
kubectl describe pod -l app=dealership
```

### Acceder al shell del contenedor:
```bash
POD_NAME=$(kubectl get pods -l app=dealership -o jsonpath='{.items[0].metadata.name}')
kubectl exec -it $POD_NAME -- /bin/bash
```

### Eliminar y recrear el deployment:
```bash
kubectl delete -f deployment.yaml
envsubst < deployment.yaml | kubectl apply -f -
```

---

## Problemas Comunes y Soluciones

### Error: "ImagePullBackOff"
**Causa:** Kubernetes no puede descargar la imagen del Container Registry

**Solución:**
```bash
# Verificar que la imagen existe
ibmcloud cr images | grep dealership

# Si no existe, construir y subir nuevamente
docker build -t us.icr.io/$MY_NAMESPACE/dealership .
docker push us.icr.io/$MY_NAMESPACE/dealership
```

### Error: "CrashLoopBackOff"
**Causa:** El contenedor se inicia pero luego falla

**Solución:**
```bash
# Ver los logs para identificar el error
kubectl logs -f deployment/dealership

# Errores comunes:
# - Migraciones fallidas: Verificar la base de datos
# - Puerto en uso: Verificar que el puerto 8000 está libre
# - Configuración incorrecta: Revisar settings.py
```

### Error: Port-forward no funciona
**Causa:** El pod no está en estado "Running"

**Solución:**
```bash
# Verificar el estado del pod
kubectl get pods

# Esperar a que esté en Running
kubectl wait --for=condition=ready pod -l app=dealership --timeout=300s

# Reintentar port-forward
kubectl port-forward deployment.apps/dealership 8000:8000
```

### Error: No se puede acceder a la aplicación
**Causa:** El servicio no está exponiendo correctamente el puerto

**Solución:**
```bash
# Verificar el servicio
kubectl get services

# Verificar los endpoints
kubectl get endpoints dealership

# Si no hay endpoints, el selector del servicio no coincide con las etiquetas del pod
kubectl describe service dealership
```

---

## Checklist Final de Envío

Antes de enviar tu proyecto, verifica:

- [ ] La imagen Docker está en IBM Cloud Container Registry
- [ ] El deployment está aplicado y en estado "Available"
- [ ] Los pods están en estado "Running"
- [ ] Puedes acceder a la aplicación via port-forward o Launch Application
- [ ] Has copiado la URL del deployment
- [ ] Todas las capturas de pantalla están tomadas
- [ ] La barra de direcciones es visible en todas las capturas
- [ ] La URL es la misma en todas las capturas
- [ ] Has iniciado sesión y probado las funcionalidades
- [ ] Has agregado al menos una reseña en el deployment

---

## Capturas de Pantalla Requeridas - Lista de Verificación

- [ ] `deployed_landingpage.png` - Página de inicio con login
- [ ] `deployed_loggedin.png` - Página de inicio autenticado
- [ ] `deployed_dealer_detail.png` - Detalles del concesionario con reseñas
- [ ] `deployed_add_review.png` - Detalles con nueva reseña agregada

---

## Limpiar Recursos (Después del envío)

```bash
# Eliminar el deployment y el servicio
kubectl delete -f deployment.yaml

# Verificar que se eliminaron
kubectl get deployments
kubectl get services
kubectl get pods
```

---

## Notas Importantes

1. **Base de datos SQLite:** La aplicación usa SQLite, por lo que los datos (usuarios, credenciales) se copiarán automáticamente al contenedor desde el archivo `db.sqlite3` local.

2. **Datos de MongoDB:** Asegúrate de que los servicios de MongoDB también estén accesibles desde el clúster de Kubernetes, o considera usar MongoDB Atlas para producción.

3. **Variables de entorno:** Si necesitas configurar variables de entorno adicionales (como MONGODB_URL), agrégalas en el deployment.yaml en la sección `env:` del contenedor.

4. **Persistencia de datos:** El contenedor usa almacenamiento efímero. Si el pod se reinicia, los datos agregados se perderán. Para producción, considera usar PersistentVolumes.

---

## Recursos Adicionales

- [Documentación de Kubernetes](https://kubernetes.io/docs/)
- [IBM Cloud Container Registry](https://cloud.ibm.com/docs/Registry)
- [Kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Guía de Troubleshooting de Kubernetes](https://kubernetes.io/docs/tasks/debug/)

---

**¡Buena suerte con tu envío!** 🚀
