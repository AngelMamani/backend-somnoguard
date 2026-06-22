enum DrowsinessLevel { Normal, Alta, Critico }

class PredictionResult {
  const PredictionResult({
    required this.Prediction,
    required this.ClaseKinetics,
    required this.Confianza,
    required this.Estado,
    required this.Alerta,
    required this.Recomendacion,
    required this.Nivel,
  });

  final String Prediction;
  final String ClaseKinetics;
  final double Confianza;
  final String Estado;
  final bool Alerta;
  final String Recomendacion;
  final DrowsinessLevel Nivel;

  factory PredictionResult.Initial() {
    return const PredictionResult(
      Prediction: 'normal',
      ClaseKinetics: '-',
      Confianza: 0,
      Estado: 'ESPERANDO',
      Alerta: false,
      Recomendacion: 'Inicia el monitoreo para analizar somnolencia.',
      Nivel: DrowsinessLevel.Normal,
    );
  }
}
