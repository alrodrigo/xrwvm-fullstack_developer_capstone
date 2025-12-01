# Guía de Despliegue en IBM Cloud

## Prerrequisitos
- IBM Cloud CLI instalado
- Docker instalado
- Acceso al entorno de IBM Cloud (Skills Network Labs)

## Pasos para Despliegue

### 1. Configurar el Espacio de Nombres de IBM Cloud Container Registry

```bash
# Exportar el namespace de SN Labs
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
echo $MY_NAMESPACE
```

### 2. Construir la Imagen Docker

Navega al directorio `server` donde está el Dockerfile:

```bash
cd server
```

Construye la imagen Docker:

```bash
docker build -t us.icr.io/$MY_NAMESPACE/dealership .
```

**Componentes del Dockerfile:**
- **Imagen Base**: `python:3.12.0-slim-bookworm`
- **Puerto Expuesto**: 8000
- **Servidor**: Gunicorn con 3 workers
- **Entrypoint**: Script que ejecuta migraciones automáticamente

### 3. Subir la Imagen al IBM Cloud Container Registry

```bash
docker push us.icr.io/$MY_NAMESPACE/dealership
```

### 4. Verificar la Imagen en el Registro

```bash
ibmcloud cr images | grep dealership
```

### 5. Crear Deployment de Kubernetes

Crea un archivo `deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dealership-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: dealership
  template:
    metadata:
      labels:
        app: dealership
    spec:
      containers:
      - name: dealership
        image: us.icr.io/<YOUR_NAMESPACE>/dealership
        ports:
        - containerPort: 8000
        env:
        - name: DJANGO_SETTINGS_MODULE
          value: "djangoproj.settings"
---
apiVersion: v1
kind: Service
metadata:
  name: dealership-service
spec:
  type: LoadBalancer
  selector:
    app: dealership
  ports:
  - protocol: TCP
    port: 8000
    targetPort: 8000
```

### 6. Aplicar el Deployment

```bash
# Reemplaza <YOUR_NAMESPACE> con tu namespace real
sed -i "s/<YOUR_NAMESPACE>/$MY_NAMESPACE/g" deployment.yaml

# Aplicar el deployment
kubectl apply -f deployment.yaml
```

### 7. Verificar el Deployment

```bash
# Ver los pods
kubectl get pods

# Ver los servicios
kubectl get services

# Ver logs de un pod específico
kubectl logs <pod-name>
```

### 8. Obtener la URL del Servicio

```bash
kubectl get service dealership-service
```

## Solución de Problemas

### Ver logs del contenedor:
```bash
kubectl logs deployment/dealership-deployment
```

### Descripción del pod:
```bash
kubectl describe pod <pod-name>
```

### Reconstruir y actualizar la imagen:
```bash
docker build -t us.icr.io/$MY_NAMESPACE/dealership .
docker push us.icr.io/$MY_NAMESPACE/dealership
kubectl rollout restart deployment/dealership-deployment
```

## Notas Importantes

1. **Entrypoint.sh**: El script ejecuta automáticamente:
   - `makemigrations`
   - `migrate`
   - `collectstatic`

2. **Gunicorn**: Servidor WSGI de producción configurado con 3 workers

3. **Variables de Entorno**: Asegúrate de configurar:
   - `SECRET_KEY` de Django
   - Credenciales de base de datos si es necesario
   - URLs de backend y sentiment analyzer

4. **Archivos Estáticos**: Se recolectan automáticamente en el entrypoint

## Arquitectura de Despliegue

```
┌─────────────────────────────────────┐
│   IBM Cloud Kubernetes Service      │
│                                     │
│  ┌──────────────────────────────┐  │
│  │  Dealership Deployment       │  │
│  │  (3 replicas)                │  │
│  │                              │  │
│  │  ┌────────────────────────┐  │  │
│  │  │  Pod 1                 │  │  │
│  │  │  Django + Gunicorn     │  │  │
│  │  │  Port 8000             │  │  │
│  │  └────────────────────────┘  │  │
│  │                              │  │
│  │  ┌────────────────────────┐  │  │
│  │  │  Pod 2                 │  │  │
│  │  └────────────────────────┘  │  │
│  │                              │  │
│  │  ┌────────────────────────┐  │  │
│  │  │  Pod 3                 │  │  │
│  │  └────────────────────────┘  │  │
│  └──────────────────────────────┘  │
│              │                     │
│              ▼                     │
│  ┌──────────────────────────────┐  │
│  │  LoadBalancer Service        │  │
│  │  External IP: xxx.xxx.xxx.xxx│  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

## Comandos Rápidos de Referencia

```bash
# Login a IBM Cloud
ibmcloud login

# Configurar región
ibmcloud target -r us-south

# Ver namespaces
ibmcloud cr namespaces

# Ver imágenes
ibmcloud cr images

# Ver contexto de Kubernetes
kubectl config current-context

# Ver todos los recursos
kubectl get all
```
