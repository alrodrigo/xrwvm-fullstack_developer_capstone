#!/bin/bash
# Script para desplegar dealership con configuraciones de seguridad PodSecurity
# Ejecutar desde: /home/project/xrwvm-fullstack_developer_capstone/server

set -e  # Exit on error

echo "=============================================="
echo " Despliegue con PodSecurity Restricted       "
echo "=============================================="
echo ""

# Verificar que estamos en el directorio correcto
if [ ! -f "deployment.yaml" ]; then
    echo "❌ Error: deployment.yaml no encontrado"
    echo "Por favor ejecuta este script desde el directorio server/"
    exit 1
fi

# Paso 1: Eliminar deployment anterior si existe
echo "📦 PASO 1: Limpiando deployment anterior..."
kubectl delete -f deployment.yaml 2>/dev/null || echo "No hay deployment previo (OK)"
sleep 2
echo "✅ Limpieza completada"
echo ""

# Paso 2: Obtener namespace
echo "🔍 PASO 2: Obteniendo namespace de Container Registry..."
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
if [ -z "$MY_NAMESPACE" ]; then
    echo "❌ Error: No se pudo obtener el namespace"
    exit 1
fi
echo "Namespace: $MY_NAMESPACE"
export SN_ICR_NAMESPACE=$MY_NAMESPACE
echo "✅ Namespace configurado"
echo ""

# Paso 3: Construir imagen Docker
echo "🐳 PASO 3: Construyendo imagen Docker con usuario no-root..."
docker build -t us.icr.io/$MY_NAMESPACE/dealership:latest .
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la construcción de la imagen"
    exit 1
fi
echo "✅ Imagen construida exitosamente"
echo ""

# Paso 4: Subir imagen al registry
echo "⬆️  PASO 4: Subiendo imagen a Container Registry..."
docker push us.icr.io/$MY_NAMESPACE/dealership:latest
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la subida de la imagen"
    exit 1
fi
echo "✅ Imagen subida exitosamente"
echo ""

# Paso 5: Verificar que la imagen existe
echo "🔍 PASO 5: Verificando imagen en registry..."
ibmcloud cr images | grep dealership
echo "✅ Imagen verificada"
echo ""

# Paso 6: Aplicar deployment
echo "🚀 PASO 6: Aplicando deployment con configuraciones de seguridad..."
envsubst < deployment.yaml | kubectl apply -f -
if [ $? -ne 0 ]; then
    echo "❌ Error: Falló la aplicación del deployment"
    exit 1
fi
echo "✅ Deployment aplicado"
echo ""

# Paso 7: Esperar a que el pod esté listo
echo "⏳ PASO 7: Esperando a que el pod esté listo (máx 5 minutos)..."
kubectl wait --for=condition=ready pod -l run=dealership --timeout=300s
if [ $? -ne 0 ]; then
    echo "⚠️  Advertencia: El pod tardó más de lo esperado"
    echo "Verificando estado..."
    kubectl get pods -l run=dealership
    echo ""
    echo "Mostrando eventos recientes:"
    kubectl get events --sort-by='.lastTimestamp' | tail -10
    echo ""
    echo "Para ver logs:"
    echo "  kubectl logs -l run=dealership"
    exit 1
fi
echo "✅ Pod listo"
echo ""

# Paso 8: Mostrar estado final
echo "=============================================="
echo " 🎉 DESPLIEGUE COMPLETADO                    "
echo "=============================================="
echo ""
echo "📊 Estado del Deployment:"
kubectl get deployments
echo ""
echo "📦 Estado de los Pods:"
kubectl get pods -o wide
echo ""
echo "🌐 Estado de los Services:"
kubectl get services
echo ""

# Paso 9: Mostrar próximos pasos
echo "=============================================="
echo " 📋 PRÓXIMOS PASOS                           "
echo "=============================================="
echo ""
echo "1. Acceder a la aplicación:"
echo "   kubectl port-forward deployment.apps/dealership 8000:8000"
echo ""
echo "2. O usar Launch Application con puerto 8000"
echo ""
echo "3. Ver logs en tiempo real:"
echo "   kubectl logs -f deployment/dealership"
echo ""
echo "4. Ver detalles del pod:"
echo "   kubectl describe pod -l run=dealership"
echo ""
echo "=============================================="
echo " 📸 CAPTURAS REQUERIDAS                      "
echo "=============================================="
echo ""
echo "Recuerda tomar las siguientes capturas con la barra de direcciones visible:"
echo ""
echo "  □ deployed_landingpage.png - Página inicio sin login"
echo "  □ deployed_loggedin.png - Página inicio autenticado"  
echo "  □ deployed_dealer_detail.png - Detalles concesionario con reseñas"
echo "  □ deployed_add_review.png - Nueva reseña agregada"
echo ""
echo "=============================================="
