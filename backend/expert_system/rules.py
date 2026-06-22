UMBRAL_ALERTA = 0.45


def Evaluar(Prediccion):
    if isinstance(Prediccion, dict):
        Etiqueta = Prediccion.get("prediction", "normal")
        Confianza = Prediccion.get("confianza", 0.0)
    else:
        Etiqueta = Prediccion
        Confianza = 1.0

    if Etiqueta == "yawning":
        Estado = "SOMNOLENCIA ALTA"
        Alerta = Confianza >= UMBRAL_ALERTA
        Recomendacion = "Detectado bostezo. Se recomienda descanso."

    elif Etiqueta == "sleeping":
        Estado = "CRITICO"
        Alerta = Confianza >= UMBRAL_ALERTA
        Recomendacion = "Posible sueno detectado. Detener conduccion."

    else:
        Estado = "NORMAL"
        Alerta = False
        Recomendacion = "Conductor estable. Continuar monitoreo."

    return {
        "estado": Estado,
        "alerta": Alerta,
        "recomendacion": Recomendacion
    }
