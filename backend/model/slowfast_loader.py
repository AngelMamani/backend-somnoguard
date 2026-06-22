import torch

from model.kinetics_labels import MapearASomnolencia, ObtenerMapaIndiceEtiqueta
from utils.video_processing import ExtraerFrames, PrepararTensorSlowFast

ModeloGlobal = None
MapaEtiquetas = None
Dispositivo = "cuda" if torch.cuda.is_available() else "cpu"


def CargarModelo():
    global ModeloGlobal, MapaEtiquetas

    if ModeloGlobal is None:
        ModeloGlobal = torch.hub.load(
            "facebookresearch/pytorchvideo",
            "slowfast_r50",
            pretrained=True
        )
        ModeloGlobal = ModeloGlobal.to(Dispositivo)
        ModeloGlobal.eval()

    if MapaEtiquetas is None:
        MapaEtiquetas = ObtenerMapaIndiceEtiqueta()

    return ModeloGlobal


def PredecirVideo(RutaVideo):
    Modelo = CargarModelo()
    Frames = ExtraerFrames(RutaVideo)
    Entrada = PrepararTensorSlowFast(Frames)

    Entrada = [Tensor.to(Dispositivo) for Tensor in Entrada]

    with torch.no_grad():
        Salida = Modelo(Entrada)

    Probabilidades = torch.softmax(Salida, dim=1)[0]
    Confianza, IndiceClase = torch.max(Probabilidades, dim=0)

    NombreClase = MapaEtiquetas.get(int(IndiceClase.item()), "desconocida")
    PrediccionSomnolencia = MapearASomnolencia(NombreClase)

    Top3 = torch.topk(Probabilidades, k=min(3, len(Probabilidades)))
    DetalleTop = []

    for Puntaje, Indice in zip(Top3.values, Top3.indices):
        Etiqueta = MapaEtiquetas.get(int(Indice.item()), "desconocida")
        DetalleTop.append({
            "clase": Etiqueta,
            "confianza": round(float(Puntaje.item()), 4)
        })

    return {
        "prediction": PrediccionSomnolencia,
        "clase_kinetics": NombreClase,
        "confianza": round(float(Confianza.item()), 4),
        "top3": DetalleTop
    }
