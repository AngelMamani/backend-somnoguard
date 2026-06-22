import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class AnimatedGradientBackground extends StatelessWidget {
  const AnimatedGradientBackground({super.key, required this.Child});

  final Widget Child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.PrimaryDark,
            AppColors.Primary,
            Color(0xFF0D2137),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.Accent.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.AccentBlue.withValues(alpha: 0.08),
              ),
            ),
          ),
          Child,
        ],
      ),
    );
  }
}
