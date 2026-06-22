import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/app_colors.dart';
import '../widgets/animated_gradient_background.dart';
import 'monitor_page.dart';
import 'settings_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedGradientBackground(
        Child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.settings_outlined),
                      color: AppColors.TextSecondary,
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  'Protege\n tu camino',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: AppColors.TextPrimary,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 16),
                Text(
                  'Monitoreo en tiempo real con IA SlowFast\ny sistema experto de alertas.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.TextSecondary,
                        height: 1.5,
                      ),
                ).animate().fadeIn(duration: 500.ms, delay: 150.ms),
                const SizedBox(height: 32),
                _FeatureTile(
                  icon: Icons.videocam_outlined,
                  title: 'Camara en vivo',
                  subtitle: 'Captura clips cortos automaticamente',
                ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.2, end: 0),
                _FeatureTile(
                  icon: Icons.psychology_outlined,
                  title: 'IA + Sistema experto',
                  subtitle: 'Detecta bostezos y niveles de riesgo',
                ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.2, end: 0),
                _FeatureTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Alertas dinamicas',
                  subtitle: 'Estados: Normal, Alta, Critico',
                ).animate().fadeIn(delay: 450.ms).slideY(begin: 0.2, end: 0),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MonitorPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Iniciar monitoreo'),
                  ),
                ).animate().fadeIn(delay: 550.ms).scale(
                      begin: const Offset(0.95, 0.95),
                      end: const Offset(1, 1),
                    ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.Surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.Accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.TextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.TextSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
