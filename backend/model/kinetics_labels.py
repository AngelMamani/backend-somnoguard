import json
import os
import urllib.request

URL_ETIQUETAS = (
    "https://dl.fbaipublicfiles.com/pyslowfast/dataset/"
    "class_names/kinetics_classnames.json"
)

RUTA_CACHE = os.path.join(os.path.dirname(__file__), "kinetics_classnames.json")

ETIQUETAS_BOSTEZO = {"yawning"}
ETIQUETAS_DORMIR = {"sleeping", "snuggling in bed", "laying on bed"}


def DescargarEtiquetas():
    if os.path.exists(RUTA_CACHE):
        with open(RUTA_CACHE, "r", encoding="utf-8") as Archivo:
            return json.load(Archivo)

    with urllib.request.urlopen(URL_ETIQUETAS, timeout=30) as Respuesta:
        Datos = json.load(Respuesta)

    with open(RUTA_CACHE, "w", encoding="utf-8") as Archivo:
        json.dump(Datos, Archivo)

    return Datos


def ObtenerMapaIndiceEtiqueta():
    Datos = DescargarEtiquetas()
    return {int(Indice): Nombre for Nombre, Indice in Datos.items()}


def MapearASomnolencia(NombreClase):
    NombreNormalizado = NombreClase.strip().lower()

    if NombreNormalizado in ETIQUETAS_BOSTEZO:
        return "yawning"

    if NombreNormalizado in ETIQUETAS_DORMIR:
        return "sleeping"

    return "normal"
