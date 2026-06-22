import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../providers/monitor_provider.dart';
import '../widgets/result_card.dart';
import '../widgets/status_indicator.dart';
import 'settings_page.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({super.key});

  @override
  State<MonitorPage> createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MonitorProvider>().InitializeCamera();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonitorProvider>(
      builder: (context, provider, _) {
        final bool isMonitoring = provider.status == MonitorStatus.monitoring;
        final bool isAnalyzing = provider.status == MonitorStatus.analyzing;
        final bool isInitializing = provider.status == MonitorStatus.initializing;

        return Scaffold(
          backgroundColor: AppColors.PrimaryDark,
          appBar: AppBar(
            title: const Text('Monitoreo activo'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {
                provider.StopMonitoring();
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                icon: Icon(
                  provider.serverOnline ? Icons.cloud_done : Icons.cloud_off,
                  color: provider.serverOnline ? AppColors.Success : AppColors.Danger,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SettingsPage()),
                  );
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 5,
                child: _CameraSection(
                  provider: provider,
                  isInitializing: isInitializing,
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.PrimaryDark,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: StatusIndicator(
                            Nivel: provider.lastResult.Nivel,
                            Estado: provider.lastResult.Estado,
                            IsAnalyzing: isAnalyzing,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (provider.errorMessage != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppColors.Danger.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              provider.errorMessage!,
                              style: const TextStyle(color: AppColors.Danger),
                            ),
                          ),
                        ResultCard(Result: provider.lastResult),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: isAnalyzing || isInitializing
                                    ? null
                                    : () => provider.AnalyzeOnce(),
                                icon: const Icon(Icons.refresh_rounded),
                                label: const Text('Analizar ahora'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.Accent,
                                  side: const BorderSide(color: AppColors.Accent),
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: isInitializing
                                    ? null
                                    : () {
                                        if (isMonitoring) {
                                          provider.StopMonitoring();
                                        } else {
                                          provider.StartMonitoring();
                                        }
                                      },
                                icon: Icon(
                                  isMonitoring ? Icons.pause : Icons.play_arrow,
                                ),
                                label: Text(isMonitoring ? 'Pausar' : 'Auto'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isMonitoring
                                      ? AppColors.Warning
                                      : AppColors.Accent,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Analisis realizados: ${provider.analysisCount}',
                          style: const TextStyle(
                            color: AppColors.TextSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CameraSection extends StatelessWidget {
  const _CameraSection({
    required this.provider,
    required this.isInitializing,
  });

  final MonitorProvider provider;
  final bool isInitializing;

  @override
  Widget build(BuildContext context) {
    final CameraController? controller = provider.cameraController;

    if (isInitializing || controller == null || !controller.value.isInitialized) {
      return Container(
        color: AppColors.Surface,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.Accent),
              SizedBox(height: 16),
              Text('Iniciando camara...', style: TextStyle(color: AppColors.TextSecondary)),
            ],
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
          child: CameraPreview(controller),
        ),
        if (provider.status == MonitorStatus.analyzing)
          Container(
            color: Colors.black38,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.Accent),
                  SizedBox(height: 12),
                  Text(
                    'Enviando al backend...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: provider.status == MonitorStatus.monitoring
                        ? AppColors.Danger
                        : AppColors.TextSecondary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  provider.status == MonitorStatus.monitoring ? 'REC' : 'CAM',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
