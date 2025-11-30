# Lista de Verificación para Revisión por Pares

## 📌 Información del Repositorio

**URL del Repositorio de GitHub:**
```
https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone
```

**Propietario:** alrodrigo  
**Rama:** main  
**Fecha:** 30 de noviembre de 2025

---

## 📸 Capturas de Pantalla Requeridas

### 1. **django_server.png / django_server.jpg**
**Descripción:** Captura de la consola/terminal mostrando que el servidor Django está corriendo.

**Qué debe incluir:**
- La salida del comando `python manage.py runserver`
- Mensaje indicando que el servidor está corriendo
- URL del servidor (http://127.0.0.1:8000/)
- Sin errores visibles

**Comando para ejecutar:**
```powershell
cd C:\Users\alrod\xrwvm-fullstack_developer_capstone\server
.\djangoenv\Scripts\Activate.ps1
python manage.py runserver
```

---

### 2. **about_us.png / about_us.jpg**
**Descripción:** Captura de la página "About Us" renderizada en el navegador.

**Qué debe incluir:**
- URL visible en la barra de direcciones: `http://localhost:8000/about/`
- Título "About Us"
- Texto de bienvenida: "Welcome to Best Cars dealership..."
- Las tres tarjetas de perfiles de personas
- Barra de navegación con "About Us" como enlace activo
- Estilos aplicados correctamente

**URL para visitar:**
```
http://localhost:8000/about/
```

---

### 3. **contact_us.png / contact_us.jpg**
**Descripción:** Captura de la página "Contact Us" renderizada en el navegador.

**Qué debe incluir:**
- URL visible en la barra de direcciones: `http://localhost:8000/contact/`
- Título "Contact Us"
- Información de contacto completa:
  - Dirección
  - Teléfonos
  - Emails
  - Redes sociales
  - Horarios de atención
- Barra de navegación con "Contact Us" como enlace activo
- Estilos aplicados correctamente

**URL para visitar:**
```
http://localhost:8000/contact/
```

---

## ✅ Pasos para Tomar las Capturas de Pantalla

### Paso 1: Iniciar el Servidor Django

1. Abre PowerShell en el directorio del proyecto
2. Navega al directorio server:
   ```powershell
   cd C:\Users\alrod\xrwvm-fullstack_developer_capstone\server
   ```
3. Activa el entorno virtual:
   ```powershell
   .\djangoenv\Scripts\Activate.ps1
   ```
4. Inicia el servidor:
   ```powershell
   python manage.py runserver
   ```

### Paso 2: Captura del Terminal

- Toma una captura de pantalla del terminal mostrando que el servidor está corriendo
- Guarda como: `django_server.png` o `django_server.jpg`

### Paso 3: Captura de la Página About

1. Abre tu navegador web
2. Ve a: `http://localhost:8000/about/`
3. Asegúrate de que la URL sea visible en la barra de direcciones
4. Toma la captura de pantalla de toda la página
5. Guarda como: `about_us.png` o `about_us.jpg`

### Paso 4: Captura de la Página Contact

1. En el mismo navegador
2. Ve a: `http://localhost:8000/contact/`
3. Asegúrate de que la URL sea visible en la barra de direcciones
4. Toma la captura de pantalla de toda la página
5. Guarda como: `contact_us.png` o `contact_us.jpg`

---

## 📂 Archivos Modificados en este Proyecto

### Configuración de Django
- ✅ `server/djangoproj/settings.py`
  - Configurado DIRS en TEMPLATES
  - Configurado STATICFILES_DIRS
  - Configurado ALLOWED_HOSTS y CSRF_TRUSTED_ORIGINS

- ✅ `server/djangoproj/urls.py`
  - Agregada ruta para `/about/`
  - Agregada ruta para `/contact/`

### Páginas Estáticas
- ✅ `server/frontend/static/About.html`
  - Enlaces CSS agregados
  - Contenido "About Us" agregado
  - Barra de navegación configurada

- ✅ `server/frontend/static/Contact.html`
  - Página creada desde cero
  - Información de contacto completa
  - Estilos personalizados
  - Barra de navegación configurada

### Base de Datos
- ✅ Migraciones ejecutadas correctamente
- ✅ Base de datos SQLite creada

---

## 🔍 Verificación Final

Antes de enviar para revisión por pares, verifica que:

- [ ] El servidor Django inicia sin errores
- [ ] La página Home (`http://localhost:8000/`) funciona
- [ ] La página About (`http://localhost:8000/about/`) funciona
- [ ] La página Contact (`http://localhost:8000/contact/`) funciona
- [ ] Todas las capturas de pantalla están tomadas y guardadas
- [ ] Las URLs son visibles en las capturas de pantalla
- [ ] El repositorio de GitHub está actualizado con todos los cambios

---

## 📝 Notas Adicionales

### URLs del Proyecto
- **Home:** `http://localhost:8000/`
- **About Us:** `http://localhost:8000/about/`
- **Contact Us:** `http://localhost:8000/contact/`
- **Admin:** `http://localhost:8000/admin/`

### Comando para Detener el Servidor
Presiona `Ctrl + C` en la terminal donde está corriendo el servidor.

### Comando para Reactivar el Entorno Virtual
```powershell
cd C:\Users\alrod\xrwvm-fullstack_developer_capstone\server
.\djangoenv\Scripts\Activate.ps1
```

---

## 🎯 Para la Revisión por Pares

Cuando envíes tu proyecto para revisión por pares, incluye:

1. ✅ URL del repositorio de GitHub
2. ✅ Captura de pantalla del servidor corriendo (`django_server.png/jpg`)
3. ✅ Captura de pantalla de la página About (`about_us.png/jpg`)
4. ✅ Captura de pantalla de la página Contact (`contact_us.png/jpg`)
5. ✅ Breve descripción de las funcionalidades implementadas

**¡Buena suerte con tu revisión por pares!** 🚀
