#!/bin/bash
# Script de despliegue para Kubernetes en IBM Cloud
# Ejecutar desde el directorio server/

echo "================================================"
echo "  Despliegue de Dealership App en Kubernetes  "
echo "================================================"
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "deployment.yaml" ]; then
    echo "❌ Error: deployment.yaml no encontrado"
    echo "Por favor ejecuta este script desde el directorio server/"
    exit 1
fi

# 1. Verificar conexión a Kubernetes
echo "1. Verificando conexión a Kubernetes..."
kubectl cluster-info
if [ $? -ne 0 ]; then
    echo "❌ Error: No se puede conectar al clúster de Kubernetes"
    exit 1
fi
echo "✅ Conexión exitosa"
echo ""

# 2. Obtener el namespace de IBM Cloud Container Registry
echo "2. Obteniendo namespace de IBM Cloud Container Registry..."
export SN_ICR_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
echo "Namespace: $SN_ICR_NAMESPACE"
if [ -z "$SN_ICR_NAMESPACE" ]; then
    echo "❌ Error: No se pudo obtener el namespace"
    exit 1
fi
echo "✅ Namespace obtenido"
echo ""

# 3. Verificar que la imagen existe
echo "3. Verificando que la imagen existe en el registro..."
ibmcloud cr images | grep dealership
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: La imagen no se encontró en el registro"
    echo "Asegúrate de haber ejecutado:"
    echo "  docker build -t us.icr.io/\$SN_ICR_NAMESPACE/dealership ."
    echo "  docker push us.icr.io/\$SN_ICR_NAMESPACE/dealership"
    read -p "¿Continuar de todos modos? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi
echo ""

# 4. Aplicar el deployment
echo "4. Aplicando deployment.yaml..."
envsubst < deployment.yaml | kubectl apply -f -
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la aplicación del deployment"
    exit 1
fi
echo "✅ Deployment aplicado exitosamente"
echo ""

# 5. Esperar a que el deployment esté listo
echo "5. Esperando a que el deployment esté listo..."
kubectl wait --for=condition=available --timeout=300s deployment/dealership
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: El deployment tardó más de lo esperado"
    echo "Verifica el estado con: kubectl get pods"
fi
echo ""

# 6. Mostrar el estado del deployment
echo "6. Estado del deployment:"
echo "------------------------"
kubectl get deployments
echo ""
kubectl get pods
echo ""
kubectl get services
echo ""

# 7. Instrucciones para port-forward
echo "================================================"
echo "  Deployment Completado                        "
echo "================================================"
echo ""
echo "Para acceder a la aplicación, ejecuta:"
echo "  kubectl port-forward deployment.apps/dealership 8000:8000"
echo ""
echo "Luego abre tu navegador en:"
echo "  http://localhost:8000"
echo ""
echo "O usa el botón 'Launch Application' con puerto 8000"
echo ""
echo "Para ver los logs:"
echo "  kubectl logs -f deployment/dealership"
echo ""
echo "Para eliminar el deployment:"
echo "  kubectl delete -f deployment.yaml"
echo ""
