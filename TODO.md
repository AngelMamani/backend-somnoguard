# Registro de Cambios

## 2026-06-19 — Deploy GitHub + Render

- `.gitignore` raiz para Python, Flutter y secretos
- `backend/Dockerfile` con PyTorch CPU + precarga SlowFast
- `render.yaml` (plan Starter recomendado)
- `README.md` con instrucciones de deploy
- `gunicorn` en requirements para produccion
- **TODO:** Conectar repo en Render (Blueprint) — repo: https://github.com/AngelMamani/backend-somnoguard
- **FIXME:** Render Blueprint con plan `starter` pedia tarjeta; cambiado a `free` en render.yaml

## 2026-06-19 — App movil SomnoGuard (Flutter)

- Clean Architecture en `cnn_3d/lib/`:
  - `domain/` — entidades, repositorios, casos de uso
  - `data/` — datasources, modelos, implementaciones
  - `presentation/` — pages, widgets, providers
  - `core/` — theme, DI, constantes
- Pantallas: Splash animado, Welcome, Monitoreo con camara, Ajustes (URL backend)
- Integracion con backend `/predict` via multipart video
- **FIXME:** Gradle falla si la ruta tiene espacios. Usar `ejecutar.bat` o trabajar desde `C:\SomnoGuard`.
- Backend muestra IPs disponibles al iniciar (`utils/network_utils.py`).
- **TODO:** Ejecutar `backend/abrir_puerto.bat` como admin si el firewall bloquea
- **TODO:** Despliegue backend en nube para uso fuera de red local

## 2026-06-19 — Pipeline real backend

- Implementado inferencia real con `torch.hub.load('facebookresearch/pytorchvideo', 'slowfast_r50')` (igual que Colab).
- `utils/video_processing.py`: extraccion de 32 frames, normalizacion y tensores Slow/Fast.
- `model/kinetics_labels.py`: mapeo de clases Kinetics-400 a `yawning`, `sleeping`, `normal`.
- `model/slowfast_loader.py`: carga lazy del modelo + prediccion con top-3.
- `expert_system/rules.py`: reglas con alerta y recomendacion.
- `app.py`: CORS, `/health`, manejo de errores y archivo temporal.
- Instalado `fvcore` en Python 3.10 (Flask usaba otro Python distinto a Anaconda).
- Creado `backend/iniciar.bat` para arrancar con el Python correcto.
- `/health` ahora muestra ruta de Python y si `fvcore` esta instalado.
- **TODO:** Probar con video real de bostezo/somnolencia desde PC.

- **TODO:** Despliegue en nube (Render/Railway) — requiere ~512MB+ RAM para el modelo.
- **FIXME:** El modelo Kinetics-400 no fue entrenado para conductores; precision limitada sin fine-tuning.

## 2026-06-19 — Estructura inicial

- Estructura base del backend creada con Flask, SlowFast, procesamiento de video y sistema experto.
