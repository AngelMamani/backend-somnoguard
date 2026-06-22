# SomnoGuard — Detección de somnolencia

Sistema móvil con **Flutter (Android)**, **backend Flask**, modelo **SlowFast** y **sistema experto**.

## Estructura

```
backend/     API REST (Flask + SlowFast)
cnn_3d/      App móvil Flutter (SomnoGuard)
```

## Backend local

```bash
cd backend
pip install -r requirements.txt
python app.py
```

Prueba: `http://localhost:5000/probar`

## App móvil

```bash
cd cnn_3d
flutter pub get
flutter run
```

En celular real, configura en Ajustes la IP de tu PC: `http://192.168.x.x:5000`

## Deploy en Render

1. Sube este repo a GitHub
2. En [Render](https://render.com) → **New** → **Blueprint** → conecta el repo
3. Usa el archivo `render.yaml` (plan **Starter** recomendado por RAM del modelo)
4. Al desplegar, copia la URL: `https://somnoguard-api.onrender.com`
5. En la app → Ajustes → pega esa URL

> El plan Free (512 MB) suele no alcanzar para PyTorch + SlowFast. Usa **Starter** o superior.

## Endpoints

| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/health` | Estado del servidor |
| POST | `/predict` | Video multipart (`video`) |
| GET | `/probar` | Página de prueba web |
