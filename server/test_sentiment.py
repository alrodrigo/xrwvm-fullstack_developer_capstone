import requests
import time

# Esperar un poco para que el servidor esté listo
time.sleep(2)

# Probar el servicio
url = "http://localhost:5000/analyze/Fantastic services"
try:
    response = requests.get(url)
    print(f"Status Code: {response.status_code}")
    print(f"Response: {response.json()}")
except Exception as e:
    print(f"Error: {e}")
