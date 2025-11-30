# Configuración de Logout (Cierre de Sesión) - Completada ✅

## 📋 Cambios Realizados

### 1. **djangoapp/views.py** ✅
**Vista `logout_request` agregada:**
```python
def logout_request(request):
    logout(request)  # Terminate user session
    data = {"userName": ""}  # Return empty username
    return JsonResponse(data)
```

**Funcionalidad:**
- Termina la sesión del usuario con `logout(request)`
- Retorna un JSON con username vacío
- Limpia la sesión del servidor

### 2. **djangoapp/urls.py** ✅
**Ruta de logout agregada:**
```python
path(route='logout', view=views.logout_request, name='logout'),
```

**URL resultante:** `/djangoapp/logout`

### 3. **frontend/static/Home.html** ✅
**Función JavaScript de logout implementada:**
```javascript
const logout = async (e) => {
  // Build logout URL and Make GET request to logout endpoint
  let logout_url = window.location.origin+"/djangoapp/logout";
  const res = await fetch(logout_url, {
    method: "GET",
  });
  const json = await res.json();
  if (json) {
    // Clear session storage and reload page
    let username = sessionStorage.getItem('username');
    sessionStorage.removeItem('username');
    window.location.href = window.location.origin;
    window.location.reload();
     // Notify user of logout
    alert("Logging out "+username+"...") 
  }
  else {
    alert("The user could not be logged out.")
  }
};
```

**Funcionalidad:**
- Hace una petición GET a `/djangoapp/logout`
- Guarda el username antes de limpiar
- Limpia sessionStorage
- Muestra alerta con el nombre del usuario
- Redirige y recarga la página

### 4. **Frontend Reconstruido** ✅
- ✅ `npm run build` ejecutado exitosamente
- ✅ Build optimizado para producción generado

---

## 🚀 Cómo Probar el Logout

### Paso 1: Asegúrate de que el Servidor esté Corriendo

El servidor Django debe estar corriendo en `http://localhost:8000/`

Si necesitas iniciarlo:
```powershell
cd C:\Users\alrod\xrwvm-fullstack_developer_capstone\server
.\djangoenv\Scripts\Activate.ps1
python manage.py runserver
```

### Paso 2: Acceder a la Aplicación

1. Abre tu navegador
2. Ve a: `http://localhost:8000/`

### Paso 3: Iniciar Sesión (si no estás logueado)

1. Haz clic en **"Login"**
2. Ingresa las credenciales del superusuario:
   - Username: (tu superusuario)
   - Password: (tu contraseña)
3. Haz clic en **"Login"**

### Paso 4: Verificar que Estás Logueado

Después del login deberías ver en la página de inicio:
- ✅ Tu **nombre de usuario** visible
- ✅ Un enlace **"Logout"** disponible

### Paso 5: Probar el Logout

1. Haz clic en el enlace **"Logout"**
2. Deberías ver una **alerta emergente** que dice:
   ```
   Logging out [tu_username]...
   ```
3. Después de cerrar la alerta:
   - La página se recargará automáticamente
   - Verás los enlaces **"Login"** y **"Register"** de nuevo
   - Tu sesión habrá terminado

---

## 📸 Captura de Pantalla Requerida

**Archivo:** `logout.jpg` o `logout.png`

### Opción 1: Captura de la Alerta
**Debe mostrar:**
- La alerta con el mensaje "Logging out [username]..."
- La URL en la barra de direcciones
- La página de fondo

### Opción 2: Captura Después del Logout
**Debe mostrar:**
- La página de inicio después de cerrar sesión
- Los enlaces "Login" y "Register" visibles (indicando que no hay sesión)
- La URL en la barra de direcciones

**Recomendación:** Toma ambas capturas para tener evidencia completa del proceso.

---

## 🔄 Flujo Completo de Logout

```
Usuario hace clic en "Logout"
         ↓
JavaScript: función logout() ejecutada
         ↓
GET request → /djangoapp/logout
         ↓
Django: logout_request(request)
         ↓
Django: logout(request) - termina sesión
         ↓
Django: retorna {"userName": ""}
         ↓
JavaScript: recibe respuesta
         ↓
JavaScript: obtiene username del sessionStorage
         ↓
JavaScript: limpia sessionStorage
         ↓
JavaScript: muestra alerta "Logging out [username]..."
         ↓
JavaScript: redirige a página de inicio
         ↓
Página se recarga - usuario ve "Login" y "Register"
```

---

## 🔍 URLs Relacionadas

### Frontend:
- **Home (con sesión)**: `http://localhost:8000/` - Muestra username + Logout
- **Home (sin sesión)**: `http://localhost:8000/` - Muestra Login + Register
- **Login Page**: `http://localhost:8000/login/`

### Backend API:
- **Login API**: `http://localhost:8000/djangoapp/login` (POST)
- **Logout API**: `http://localhost:8000/djangoapp/logout` (GET)

---

## 🧪 Verificación del SessionStorage

### Durante la sesión activa:
Abre la consola del navegador (F12) y ejecuta:
```javascript
sessionStorage.getItem('username')
```
Debería mostrar tu nombre de usuario.

### Después del logout:
Ejecuta el mismo comando:
```javascript
sessionStorage.getItem('username')
```
Debería retornar `null` (sesión limpiada).

---

## 🔧 Troubleshooting

### Problema: "La alerta no aparece"
**Soluciones:**
1. Verifica que reconstruiste el frontend con `npm run build`
2. Limpia la caché del navegador (Ctrl+Shift+Del)
3. Prueba en modo incógnito o en otro navegador
4. Verifica la consola del navegador (F12) para errores JavaScript

### Problema: "Sigo viendo mi username después del logout"
**Soluciones:**
1. Recarga la página manualmente (F5)
2. Limpia el sessionStorage manualmente:
   ```javascript
   sessionStorage.clear()
   ```
3. Verifica que el código de logout se ejecutó sin errores

### Problema: "Error 404 en /djangoapp/logout"
**Soluciones:**
1. Verifica que agregaste la ruta en `djangoapp/urls.py`
2. Asegúrate de que el servidor Django se reinició
3. Verifica la URL en la consola del navegador

---

## ✅ Checklist Final

Antes de tomar la captura de pantalla:

- [ ] Servidor Django corriendo sin errores
- [ ] Frontend reconstruido con `npm run build`
- [ ] Puedes iniciar sesión correctamente
- [ ] Después del login, ves tu username y el enlace "Logout"
- [ ] Al hacer clic en "Logout", aparece la alerta
- [ ] Después de la alerta, la página se recarga
- [ ] Después del logout, ves "Login" y "Register"
- [ ] Captura de pantalla tomada y guardada como `logout.jpg` o `logout.png`

---

## 📝 Archivos Modificados

1. ✅ `server/djangoapp/views.py` - Vista logout_request agregada
2. ✅ `server/djangoapp/urls.py` - Ruta de logout configurada
3. ✅ `server/frontend/static/Home.html` - Función JavaScript de logout
4. ✅ `server/frontend/build/` - Frontend reconstruido

---

## 🎯 Estado Actual

**Sistema de Autenticación Completo:**
- ✅ **Login** - Usuarios pueden iniciar sesión
- ✅ **Logout** - Usuarios pueden cerrar sesión
- ✅ **Persistencia de sesión** - Username guardado en sessionStorage
- ✅ **UI dinámica** - Cambia según el estado de autenticación

**Próximos pasos sugeridos:**
1. Implementar funcionalidad de Registro (Registration)
2. Agregar vistas de dealerships
3. Implementar sistema de reviews

---

## 💡 Notas Importantes

- El logout es un proceso **GET**, no requiere CSRF token
- El logout limpia tanto la sesión del servidor (Django) como del cliente (sessionStorage)
- La alerta es importante para que el usuario sepa que el proceso se completó
- El navegador puede cachear la página, por eso se incluye `window.location.reload()`

**¡El sistema de logout está completamente funcional!** 🎉
