# Full Stack Developer Capstone Project

[![Lint Code](https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone/actions/workflows/main.yml/badge.svg)](https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone/actions/workflows/main.yml)

## Descripción del Proyecto

Aplicación web full-stack de concesionarios de autos con sistema de reseñas y análisis de sentimientos.

## Arquitectura

### Backend
- **Django 5.2.8**: API REST y administración
- **Node.js + Express**: Microservicio de base de datos
- **MongoDB**: Base de datos de concesionarios y reseñas
- **Flask**: Microservicio de análisis de sentimientos con NLTK

### Frontend
- **React**: Interfaz de usuario
- **React Router**: Navegación

## CI/CD

El proyecto utiliza GitHub Actions para integración y despliegue continuo:

### Workflows Configurados

#### Lint Code (main.yml)
Se ejecuta automáticamente en:
- Push a las ramas `main` o `master`
- Pull requests a las ramas `main` o `master`

**Jobs:**
1. **lint_python**: Verifica código Python con flake8
2. **lint_js**: Verifica código JavaScript con JSHint

## Características Principales

- ✅ Sistema de autenticación de usuarios
- ✅ Listado de concesionarios con filtros por estado
- ✅ Sistema de reseñas para concesionarios
- ✅ Análisis de sentimientos automático (positive/neutral/negative)
- ✅ Panel de administración Django
- ✅ API REST completa
- ✅ Linting automático con GitHub Actions

## Tecnologías Utilizadas

- Python 3.13
- Django 5.2.8
- Node.js 18.12.1
- MongoDB (latest)
- Flask
- React
- Docker & Docker Compose
- NLTK (Natural Language Toolkit)
- GitHub Actions

## Instalación y Ejecución

### Prerrequisitos
- Python 3.13+
- Node.js 18+
- Docker Desktop
- Git

### Configuración

1. Clonar el repositorio:
```bash
git clone https://github.com/alrodrigo/xrwvm-fullstack_developer_capstone.git
cd xrwvm-fullstack_developer_capstone
```

2. Iniciar servicios Docker (MongoDB + Node.js API):
```bash
cd server/database
docker build . -t nodeapp
docker compose up
```

3. Configurar entorno Python y Django:
```bash
cd server
python -m venv djangoenv
source djangoenv/bin/activate  # En Windows: djangoenv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

4. Iniciar microservicio de análisis de sentimientos:
```bash
cd server/djangoapp/microservices
python app.py
```

5. Construir frontend:
```bash
cd server/frontend
npm install
npm run build
```

## Endpoints API

### Django API
- `GET /djangoapp/get_dealers` - Lista todos los concesionarios
- `GET /djangoapp/get_dealers/<state>` - Concesionarios por estado
- `GET /djangoapp/dealer/<dealer_id>` - Detalles de un concesionario
- `GET /djangoapp/reviews/dealer/<dealer_id>` - Reseñas con análisis de sentimientos
- `POST /djangoapp/add_review` - Publicar reseña (requiere autenticación)
- `GET /djangoapp/get_cars` - Lista de modelos de autos

### Node.js API
- `GET /fetchDealers` - Todos los concesionarios
- `GET /fetchDealers/<state>` - Concesionarios por estado
- `GET /fetchDealer/<id>` - Concesionario específico
- `GET /fetchReviews` - Todas las reseñas
- `GET /fetchReviews/dealer/<id>` - Reseñas por concesionario
- `POST /insert_review` - Insertar nueva reseña

### Microservicio de Sentimientos
- `GET /analyze/<text>` - Analizar sentimiento de texto

## Contribución

Las contribuciones son bienvenidas. Por favor:

1. Crea un fork del proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

**Nota:** El código debe pasar los checks de linting antes de ser fusionado.

## Autor

- **alrodrigo**

## Licencia

Este proyecto es parte del IBM Full Stack Developer Capstone Project.