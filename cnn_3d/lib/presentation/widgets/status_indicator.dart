import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/prediction_result.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    super.key,
    required this.Nivel,
    required this.Estado,
    required this.IsAnalyzing,
  });

  final DrowsinessLevel Nivel;
  final String Estado;
  final bool IsAnalyzing;

  Color _GetColor() {
    if (IsAnalyzing) return AppColors.AccentBlue;

    switch (Nivel) {
      case DrowsinessLevel.Critico:
        return AppColors.Danger;
      case DrowsinessLevel.Alta:
        return AppColors.Warning;
      case DrowsinessLevel.Normal:
        return AppColors.Success;
    }
  }

  IconData _GetIcon() {
    if (IsAnalyzing) return Icons.sync;

    switch (Nivel) {
      case DrowsinessLevel.Critico:
        return Icons.warning_amber_rounded;
      case DrowsinessLevel.Alta:
        return Icons.bedtime_rounded;
      case DrowsinessLevel.Normal:
        return Icons.check_circle_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color ColorEstado = _GetColor();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: ColorEstado.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColorEstado.withValues(alpha: 0.6), width: 2),
        boxShadow: [
          BoxShadow(
            color: ColorEstado.withValues(alpha: 0.25),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_GetIcon(), color: ColorEstado, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                IsAnalyzing ? 'ANALIZANDO...' : Estado,
                style: TextStyle(
                  color: ColorEstado,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.1,
                ),
              ),
              if (!IsAnalyzing)
                Text(
                  _GetSubtitle(),
                  style: const TextStyle(
                    color: AppColors.TextSecondary,
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _GetSubtitle() {
    switch (Nivel) {
      case DrowsinessLevel.Critico:
        return 'Detener conduccion';
      case DrowsinessLevel.Alta:
        return 'Somnolencia detectada';
      case DrowsinessLevel.Normal:
        return 'Conductor estable';
    }
  }
}
