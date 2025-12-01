# Despliegue Rápido en Kubernetes

## 📋 Comandos Rápidos

### 1. Preparar la Imagen Docker
```bash
cd server
MY_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
docker build -t us.icr.io/$MY_NAMESPACE/dealership .
docker push us.icr.io/$MY_NAMESPACE/dealership
```

### 2. Desplegar en Kubernetes
```bash
export SN_ICR_NAMESPACE=$(ibmcloud cr namespaces | grep sn-labs-)
envsubst < deployment.yaml | kubectl apply -f -
```

### 3. Verificar el Despliegue
```bash
kubectl get deployments
kubectl get pods
kubectl get services
```

### 4. Acceder a la Aplicación
```bash
kubectl port-forward deployment.apps/dealership 8000:8000
```

Luego abre: http://localhost:8000

---

## 📸 Capturas de Pantalla Requeridas

### Checklist de Capturas:
- [ ] `deployed_landingpage.png` - Página de inicio con pantalla de login
- [ ] `deployed_loggedin.png` - Página de inicio con usuario autenticado
- [ ] `deployed_dealer_detail.png` - Detalles del concesionario con reseñas
- [ ] `deployed_add_review.png` - Detalles con nueva reseña agregada

### URLs a Capturar:
1. **Landing Page**: `http://localhost:8000/` (sin autenticar)
2. **Logged In**: `http://localhost:8000/` (autenticado)
3. **Dealer Detail**: `http://localhost:8000/dealer/[ID]`
4. **After Review**: `http://localhost:8000/dealer/[ID]` (después de agregar reseña)

### ⚠️ IMPORTANTE:
- La barra de direcciones debe ser VISIBLE en todas las capturas
- La URL debe ser la MISMA en todas las capturas
- Todas las capturas deben ser del deployment de Kubernetes (no local)

---

## 🔧 Troubleshooting Rápido

### Pod no inicia:
```bash
kubectl logs -f deployment/dealership
kubectl describe pod -l app=dealership
```

### ImagePullBackOff:
```bash
ibmcloud cr images | grep dealership
# Si no está, reconstruir y subir
```

### Port-forward falla:
```bash
kubectl wait --for=condition=ready pod -l app=dealership --timeout=300s
kubectl port-forward deployment.apps/dealership 8000:8000
```

### Reiniciar deployment:
```bash
kubectl rollout restart deployment/dealership
```

### Eliminar y recrear:
```bash
kubectl delete -f deployment.yaml
envsubst < deployment.yaml | kubectl apply -f -
```

---

## 📊 Verificación de Estado

### Estado Saludable:
```
DEPLOYMENT:  1/1 READY
POD:         Running
SERVICE:     NodePort con puerto 8000
```

### Comandos de Verificación:
```bash
# Estado general
kubectl get all

# Logs en tiempo real
kubectl logs -f deployment/dealership

# Eventos del deployment
kubectl describe deployment dealership

# Endpoints del servicio
kubectl get endpoints dealership
```

---

## 🎯 Flujo de Capturas de Pantalla

1. **Inicia port-forward**: `kubectl port-forward deployment.apps/dealership 8000:8000`
2. **Abre navegador**: `http://localhost:8000`
3. **Captura 1**: Landing page sin login → `deployed_landingpage.png`
4. **Login**: Usa credenciales existentes (ej: root/root)
5. **Captura 2**: Página principal autenticado → `deployed_loggedin.png`
6. **Navega**: Click en "Dealers" → Click en un dealer
7. **Captura 3**: Página de detalles con reseñas → `deployed_dealer_detail.png`
8. **Agrega reseña**: Click en "Post Review" → Completa formulario → Submit
9. **Captura 4**: Página de detalles con nueva reseña → `deployed_add_review.png`

---

## 🧹 Limpieza (Después del envío)

```bash
kubectl delete -f deployment.yaml
kubectl get all  # Verificar que se eliminó
```

---

## 📚 Documentación Completa

Ver `KUBERNETES_DEPLOYMENT.md` para:
- Instrucciones detalladas paso a paso
- Troubleshooting avanzado
- Configuración de variables de entorno
- Persistencia de datos
- Mejores prácticas

---

## ✅ Checklist Final

- [ ] Imagen construida y subida a IBM CR
- [ ] Deployment aplicado exitosamente
- [ ] Pod en estado "Running"
- [ ] Port-forward funcionando
- [ ] Aplicación accesible en navegador
- [ ] 4 capturas de pantalla tomadas
- [ ] Barra de direcciones visible en todas
- [ ] URL consistente en todas las capturas
- [ ] Proyecto listo para envío

---

**Need Help?** Consulta `KUBERNETES_DEPLOYMENT.md` para guía detallada.
