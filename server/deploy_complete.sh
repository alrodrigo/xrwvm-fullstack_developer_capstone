#!/bin/bash
# Script para construir y desplegar todas las imágenes necesarias
set -e

echo "=============================================="
echo " Build y Deploy Completo - Dealership App    "
echo "=============================================="
echo ""

# Obtener namespace
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
if [ -z "$MY_NAMESPACE" ]; then
    echo "❌ Error: No se pudo obtener el namespace"
    exit 1
fi
echo "Namespace: $MY_NAMESPACE"
export SN_ICR_NAMESPACE=$MY_NAMESPACE
echo ""

# Build 1: Django App (con React frontend)
echo "=== 1/4: Construyendo Django App ==="
cd /home/project/xrwvm-fullstack_developer_capstone/server
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .
docker push us.icr.io/$MY_NAMESPACE/dealership:latest
echo "✅ Django App construida y subida"
echo ""

# Build 2: Node.js Backend
echo "=== 2/4: Construyendo Node.js Backend ==="
cd /home/project/xrwvm-fullstack_developer_capstone/server/database
docker build -t us.icr.io/$MY_NAMESPACE/nodebackend:latest .
docker push us.icr.io/$MY_NAMESPACE/nodebackend:latest
echo "✅ Node.js Backend construido y subido"
echo ""

# Build 3: Sentiment Analyzer
echo "=== 3/4: Construyendo Sentiment Analyzer ==="
cd /home/project/xrwvm-fullstack_developer_capstone/server/djangoapp/microservices
docker build -t us.icr.io/$MY_NAMESPACE/sentiment:latest .
docker push us.icr.io/$MY_NAMESPACE/sentiment:latest
echo "✅ Sentiment Analyzer construido y subido"
echo ""

# Deploy 4: Aplicar Kubernetes Deployment
echo "=== 4/4: Desplegando en Kubernetes ==="
cd /home/project/xrwvm-fullstack_developer_capstone/server

# Eliminar deployment anterior si existe
kubectl delete -f deployment-full.yaml 2>/dev/null || echo "No hay deployment previo"
sleep 2

# Aplicar el deployment completo
envsubst < deployment-full.yaml | kubectl apply -f -

echo "✅ Deployment aplicado"
echo ""

# Esperar a que el pod esté listo
echo "⏳ Esperando a que el pod esté listo (máx 5 minutos)..."
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s

echo ""
echo "=============================================="
echo " 🎉 DESPLIEGUE COMPLETADO                    "
echo "=============================================="
echo ""

# Mostrar estado
echo "📊 Estado:"
kubectl get pods -o wide
echo ""
kubectl get services
echo ""

# Ver logs
echo "📋 Logs recientes:"
kubectl logs -l run=dealership --tail=30 --all-containers=true
echo ""

echo "=============================================="
echo " Para acceder a la aplicación:               "
echo "=============================================="
echo ""
echo "  kubectl port-forward deployment.apps/dealership 8000:8000"
echo ""
echo "Luego usa Launch Application con puerto 8000"
echo ""
