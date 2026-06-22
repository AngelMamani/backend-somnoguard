import cv2
import numpy as np
import torch

FORMATOS_PERMITIDOS = {".mp4", ".avi", ".mov", ".mkv", ".webm"}

FRAMES_SLOW = 8
FRAMES_FAST = 32
ALTURA_OBJETIVO = 256
ANCHO_OBJETIVO = 256

MEDIA = np.array([0.45, 0.45, 0.45], dtype=np.float32)
DESVIACION = np.array([0.225, 0.225, 0.225], dtype=np.float32)


def ValidarVideo(NombreArchivo):
    if not NombreArchivo or "." not in NombreArchivo:
        return False

    Extension = NombreArchivo.lower()[NombreArchivo.rfind("."):]
    return Extension in FORMATOS_PERMITIDOS


def ExtraerFrames(RutaVideo, CantidadFrames=FRAMES_FAST):
    Captura = cv2.VideoCapture(RutaVideo)

    if not Captura.isOpened():
        raise ValueError(f"No se pudo abrir el video: {RutaVideo}")

    TotalFrames = int(Captura.get(cv2.CAP_PROP_FRAME_COUNT))

    if TotalFrames <= 0:
        Captura.release()
        raise ValueError("El video no contiene frames validos")

    CantidadFinal = min(CantidadFrames, TotalFrames)
    Indices = np.linspace(0, TotalFrames - 1, CantidadFinal, dtype=int)

    Frames = []

    for Indice in Indices:
        Captura.set(cv2.CAP_PROP_POS_FRAMES, int(Indice))
        Exito, Frame = Captura.read()

        if Exito:
            Frame = cv2.cvtColor(Frame, cv2.COLOR_BGR2RGB)
            Frame = cv2.resize(Frame, (ANCHO_OBJETIVO, ALTURA_OBJETIVO))
            Frames.append(Frame)

    Captura.release()

    if len(Frames) == 0:
        raise ValueError("No se pudieron extraer frames del video")

    return Frames


def PrepararTensorSlowFast(Frames):
    Video = np.stack(Frames, axis=0).astype(np.float32) / 255.0
    Video = (Video - MEDIA) / DESVIACION

    Tensor = torch.from_numpy(Video).permute(3, 0, 1, 2)
    NumFrames = Tensor.shape[1]

    IndicesSlow = torch.linspace(0, NumFrames - 1, FRAMES_SLOW).long()
    IndicesFast = torch.linspace(0, NumFrames - 1, FRAMES_FAST).long()

    RutaSlow = Tensor[:, IndicesSlow, :, :].unsqueeze(0)
    RutaFast = Tensor[:, IndicesFast, :, :].unsqueeze(0)

    return [RutaSlow, RutaFast]
