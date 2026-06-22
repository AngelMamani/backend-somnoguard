import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../widgets/animated_gradient_background.dart';
import 'welcome_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), _GoToWelcome);
  }

  void _GoToWelcome() {
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const WelcomePage(),
        transitionsBuilder: (_, Animation, __, Child) {
          return FadeTransition(opacity: Animation, child: Child);
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        Child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppColors.Accent, AppColors.AccentBlue],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.Accent.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.visibility_rounded,
                    size: 56,
                    color: AppColors.PrimaryDark,
                  ),
                )
                    .animate(onPlay: (Controller) => Controller.repeat())
                    .shimmer(duration: 1800.ms, color: Colors.white24)
                    .scale(
                      begin: const Offset(0.92, 0.92),
                      end: const Offset(1, 1),
                      duration: 1200.ms,
                      curve: Curves.easeInOut,
                    ),
                const SizedBox(height: 32),
                Text(
                  'SomnoGuard',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.TextPrimary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0),
                const SizedBox(height: 12),
                Text(
                  'Deteccion inteligente de somnolencia',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.TextSecondary,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 400.ms),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.Accent,
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
