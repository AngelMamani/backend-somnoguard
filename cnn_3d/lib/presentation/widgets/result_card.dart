import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/prediction_result.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.Result,
  });

  final PredictionResult Result;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.Surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ultimo analisis',
            style: TextStyle(
              color: AppColors.TextSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 10),
          _InfoRow('Prediccion', Result.Prediction),
          _InfoRow('Clase IA', Result.ClaseKinetics),
          _InfoRow('Confianza', '${(Result.Confianza * 100).toStringAsFixed(1)}%'),
          const SizedBox(height: 8),
          Text(
            Result.Recomendacion,
            style: const TextStyle(
              color: AppColors.TextPrimary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _InfoRow(String Label, String Value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Label, style: const TextStyle(color: AppColors.TextSecondary)),
          Text(
            Value,
            style: const TextStyle(
              color: AppColors.TextPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
