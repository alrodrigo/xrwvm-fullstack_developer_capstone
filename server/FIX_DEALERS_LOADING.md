# 🔧 Solución: Dealers No Cargan

## 🐛 Problema

Los dealers no cargan porque:
- El backend de Node.js (MongoDB) no está desplegado en Kubernetes
- El sentiment analyzer no está disponible
- Django intenta conectarse a `localhost:3030` pero no hay nada escuchando

## ✅ Solución

Desplegar **todos los servicios necesarios** en un solo pod con múltiples contenedores:
1. **MongoDB** - Base de datos
2. **Node.js Backend** - API de dealers y reviews
3. **Django** - Backend principal con React frontend
4. **Sentiment Analyzer** - Microservicio Flask

---

## 📋 Pasos de Despliegue

### Paso 1: Actualizar el Repositorio

```bash
cd /home/project/xrwvm-fullstack_developer_capstone
git pull origin main
cd server
```

### Paso 2: Ejecutar el Script Automatizado

```bash
chmod +x deploy_complete.sh
./deploy_complete.sh
```

Este script:
- Construye la imagen de Django (con React frontend)
- Construye la imagen del backend Node.js
- Construye la imagen del sentiment analyzer
- Sube las 3 imágenes a Container Registry
- Despliega todos los servicios en Kubernetes

**Tiempo total:** 5-7 minutos

### Paso 3: Verificar el Despliegue

```bash
# Ver el estado del pod
kubectl get pods

# Debe mostrar 1/1 READY con 4 contenedores dentro
kubectl get pods -o jsonpath='{.items[0].spec.containers[*].name}'
```

**Salida esperada:**
```
mongodb nodebackend dealership sentiment
```

### Paso 4: Ver Logs de Todos los Contenedores

```bash
# Logs del backend Node.js
kubectl logs -l run=dealership -c nodebackend

# Logs de Django
kubectl logs -l run=dealership -c dealership

# Logs del sentiment analyzer
kubectl logs -l run=dealership -c sentiment

# Logs de todos los contenedores
kubectl logs -l run=dealership --all-containers=true
```

### Paso 5: Acceder a la Aplicación

```bash
kubectl port-forward deployment.apps/dealership 8000:8000
```

Luego usa **Launch Application** con puerto **8000**.

---

## 🔍 Verificación

### 1. Verificar que MongoDB está corriendo

```bash
POD_NAME=$(kubectl get pods -l run=dealership -o jsonpath='{.items[0].metadata.name}')
kubectl exec $POD_NAME -c mongodb -- mongosh --eval "db.version()"
```

### 2. Verificar que Node.js está corriendo

```bash
kubectl logs -l run=dealership -c nodebackend | tail -10
```

**Buscar:**
```
Connected to MongoDB
Express app listening on port 3030
```

### 3. Probar el endpoint de dealers

En la aplicación, abre la consola del navegador (F12) y ve a la pestaña Network. Luego:
- Navega a `/dealers`
- Verifica que aparece una petición a `/djangoapp/get_dealers`
- Status debe ser **200**
- Response debe contener un array de dealers

---

## 📸 Capturas de Pantalla

Una vez desplegado, puedes tomar las capturas:

1. **deployed_landingpage.png** - Landing page
2. **deployed_loggedin.png** - Logged in (usa root/root)
3. **deployed_dealer_detail.png** - Dealers page con tabla llena
4. **deployed_add_review.png** - Dealer detail con reviews

---

## 🚨 Troubleshooting

### Problema: Pod no inicia (CrashLoopBackOff)

**Causa:** Alguno de los contenedores falla al iniciar

**Solución:**
```bash
# Ver cuál contenedor falla
kubectl describe pod -l run=dealership

# Ver logs del contenedor que falla
kubectl logs -l run=dealership -c <container-name>
```

### Problema: MongoDB rechaza conexión

**Causa:** MongoDB no permite usuario 999

**Solución:** Ya actualizado en `deployment-full.yaml` con `runAsUser: 999`

### Problema: Node.js no se conecta a MongoDB

**Causa:** MongoDB aún no está listo cuando Node.js inicia

**Solución:** Agregar un initContainer o reiniciar el pod:
```bash
kubectl rollout restart deployment dealership
```

### Problema: Dealers cargan pero reviews no

**Causa:** Sentiment analyzer no está respondiendo

**Verificar:**
```bash
kubectl logs -l run=dealership -c sentiment
```

**Buscar:**
```
* Running on http://0.0.0.0:5000
```

### Problema: "No dealers found"

**Causa:** MongoDB no tiene datos

**Solución:** Los datos se cargan automáticamente al iniciar Node.js desde `data/dealerships.json`

**Verificar:**
```bash
kubectl logs -l run=dealership -c nodebackend | grep -i "insert\|seed"
```

---

## 📐 Arquitectura del Deployment

```
┌─────────────────────────────────────────┐
│           Kubernetes Pod                │
│                                         │
│  ┌───────────┐  ┌──────────────┐      │
│  │  MongoDB  │  │   Node.js    │      │
│  │  :27017   │◄─┤   Backend    │      │
│  └───────────┘  │   :3030      │      │
│                  └──────────────┘      │
│        ▲                               │
│        │         ┌──────────────┐      │
│        │         │   Sentiment  │      │
│        │         │   Analyzer   │      │
│        │         │   :5000      │      │
│        │         └──────────────┘      │
│        │                ▲              │
│        │                │              │
│  ┌─────┴────────────────┴────┐        │
│  │      Django + React        │        │
│  │         :8000              │        │
│  └────────────────────────────┘        │
│                 │                      │
└─────────────────┼──────────────────────┘
                  │
                  ▼
          ┌───────────────┐
          │   Service     │
          │  NodePort     │
          │   :8000       │
          └───────────────┘
```

---

## 🎯 Comandos Rápidos

### Build y Deploy Todo
```bash
cd /home/project/xrwvm-fullstack_developer_capstone/server
chmod +x deploy_complete.sh
./deploy_complete.sh
```

### Ver Estado
```bash
kubectl get all
kubectl logs -l run=dealership --all-containers=true --tail=50
```

### Reiniciar el Deployment
```bash
kubectl rollout restart deployment dealership
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s
```

### Eliminar Todo
```bash
kubectl delete -f deployment-full.yaml
```

---

## ✅ Checklist

- [ ] `git pull` ejecutado
- [ ] Script `deploy_complete.sh` ejecutado
- [ ] 3 imágenes construidas y subidas
- [ ] Pod en estado "Running" (1/1 READY)
- [ ] 4 contenedores corriendo en el pod
- [ ] MongoDB conectado
- [ ] Node.js backend respondiendo
- [ ] Sentiment analyzer funcionando
- [ ] Django sirviendo frontend
- [ ] `/dealers` carga la tabla con datos
- [ ] `/dealer/[ID]` muestra reseñas
- [ ] Listo para capturas

---

**Archivos actualizados:**
- `deployment-full.yaml` - Deployment con 4 contenedores
- `database/Dockerfile` - Node.js con usuario no-root
- `djangoapp/microservices/Dockerfile` - Sentiment con usuario no-root
- `deploy_complete.sh` - Script automatizado

**Próximo paso:** Ejecuta `./deploy_complete.sh` en IBM Cloud Terminal 🚀
