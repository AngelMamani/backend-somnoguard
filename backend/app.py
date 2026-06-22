import os
import sys
import tempfile
import uuid

from flask import Flask, jsonify, request, render_template_string
from flask_cors import CORS

from expert_system.rules import Evaluar
from model.slowfast_loader import PredecirVideo
from utils.network_utils import ImprimirUrlsBackend
from utils.video_processing import ValidarVideo

app = Flask(__name__)
CORS(app)


@app.route("/", methods=["GET"])
def Home():
    return jsonify({
        "mensaje": "Backend de deteccion de somnolencia activo",
        "endpoints": ["/health", "/predict", "/probar"]
    })


PAGINA_PRUEBA = """
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Probar deteccion de somnolencia</title>
    <style>
        body { font-family: Arial, sans-serif; max-width: 640px; margin: 40px auto; padding: 0 16px; }
        h1 { font-size: 1.4rem; }
        input, button { margin-top: 12px; }
        button { padding: 10px 20px; cursor: pointer; }
        pre { background: #f4f4f4; padding: 16px; border-radius: 8px; white-space: pre-wrap; }
        .nota { color: #666; font-size: 0.9rem; }
    </style>
</head>
<body>
    <h1>Probar backend - Somnolencia</h1>
    <p class="nota">Sube un video MP4 (2-5 seg, cara visible). La primera vez puede tardar por descarga del modelo.</p>
    <input type="file" id="video" accept="video/*"><br>
    <button onclick="enviar()">Analizar video</button>
    <p id="estado"></p>
    <pre id="resultado"></pre>
    <script>
        async function enviar() {
            const archivo = document.getElementById("video").files[0];
            const estado = document.getElementById("estado");
            const resultado = document.getElementById("resultado");
            if (!archivo) {
                alert("Selecciona un video primero");
                return;
            }
            estado.textContent = "Procesando... puede tardar 1-3 min la primera vez.";
            resultado.textContent = "";
            const formData = new FormData();
            formData.append("video", archivo);
            try {
                const resp = await fetch("/predict", { method: "POST", body: formData });
                const data = await resp.json();
                estado.textContent = resp.ok ? "Listo" : "Error " + resp.status;
                resultado.textContent = JSON.stringify(data, null, 2);
            } catch (e) {
                estado.textContent = "Error de conexion";
                resultado.textContent = e.message;
            }
        }
    </script>
</body>
</html>
"""


@app.route("/probar", methods=["GET"])
def Probar():
    return render_template_string(PAGINA_PRUEBA)


@app.route("/health", methods=["GET"])
def Health():
    try:
        import fvcore
        FvcoreOk = True
        VersionFvcore = fvcore.__version__
    except ImportError:
        FvcoreOk = False
        VersionFvcore = None

    return jsonify({
        "status": "ok",
        "python": sys.executable,
        "fvcore": FvcoreOk,
        "fvcore_version": VersionFvcore
    })


@app.route("/predict", methods=["POST"])
def Predict():
    if "video" not in request.files:
        return jsonify({"error": "Debes enviar un archivo en el campo 'video'"}), 400

    ArchivoVideo = request.files["video"]
    NombreArchivo = ArchivoVideo.filename or ""

    ArchivoVideo.seek(0, os.SEEK_END)
    TamanoArchivo = ArchivoVideo.tell()
    ArchivoVideo.seek(0)

    if TamanoArchivo == 0:
        return jsonify({
            "error": "No se recibio el video. En Postman: Body > form-data > video > File > Select Files"
        }), 400

    if NombreArchivo == "":
        NombreArchivo = "video.mp4"

    if not ValidarVideo(NombreArchivo):
        return jsonify({"error": "Formato no soportado. Usa mp4, avi, mov, mkv o webm"}), 400

    Extension = os.path.splitext(NombreArchivo)[1].lower()
    RutaTemporal = os.path.join(
        tempfile.gettempdir(),
        f"clip_{uuid.uuid4().hex}{Extension}"
    )

    try:
        ArchivoVideo.save(RutaTemporal)
        Prediccion = PredecirVideo(RutaTemporal)
        ResultadoExperto = Evaluar(Prediccion)

        return jsonify({
            "prediction": Prediccion["prediction"],
            "clase_kinetics": Prediccion["clase_kinetics"],
            "confianza": Prediccion["confianza"],
            "top3": Prediccion["top3"],
            "estado": ResultadoExperto["estado"],
            "alerta": ResultadoExperto["alerta"],
            "recomendacion": ResultadoExperto["recomendacion"]
        })

    except Exception as Error:
        return jsonify({"error": str(Error)}), 500

    finally:
        if os.path.exists(RutaTemporal):
            os.remove(RutaTemporal)


if __name__ == "__main__":
    Puerto = int(os.environ.get("PORT", 5000))
    EsProduccion = os.environ.get("RENDER") == "true"

    if not EsProduccion:
        ImprimirUrlsBackend(Puerto=Puerto)

    app.run(host="0.0.0.0", port=Puerto, debug=not EsProduccion)
