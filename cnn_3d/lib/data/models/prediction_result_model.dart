import '../../domain/entities/prediction_result.dart';

class PredictionResultModel extends PredictionResult {
  const PredictionResultModel({
    required super.Prediction,
    required super.ClaseKinetics,
    required super.Confianza,
    required super.Estado,
    required super.Alerta,
    required super.Recomendacion,
    required super.Nivel,
  });

  factory PredictionResultModel.FromJson(Map<String, dynamic> Json) {
    final String Estado = Json['estado']?.toString() ?? 'NORMAL';
    final DrowsinessLevel Nivel = _MapNivel(Estado);

    return PredictionResultModel(
      Prediction: Json['prediction']?.toString() ?? 'normal',
      ClaseKinetics: Json['clase_kinetics']?.toString() ?? '-',
      Confianza: _ParseDouble(Json['confianza']),
      Estado: Estado,
      Alerta: Json['alerta'] == true,
      Recomendacion: Json['recomendacion']?.toString() ?? '',
      Nivel: Nivel,
    );
  }

  static double _ParseDouble(dynamic Value) {
    if (Value is num) return Value.toDouble();
    return double.tryParse(Value?.toString() ?? '0') ?? 0;
  }

  static DrowsinessLevel _MapNivel(String Estado) {
    final String Normalizado = Estado.toUpperCase();

    if (Normalizado.contains('CRITICO')) {
      return DrowsinessLevel.Critico;
    }

    if (Normalizado.contains('ALTA')) {
      return DrowsinessLevel.Alta;
    }

    return DrowsinessLevel.Normal;
  }
}
