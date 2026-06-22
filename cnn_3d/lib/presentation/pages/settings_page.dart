import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/api_constants.dart';
import '../../core/theme/app_colors.dart';
import '../providers/settings_provider.dart';
import '../widgets/animated_gradient_background.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<SettingsProvider>().LoadSettings();
      _urlController.text = context.read<SettingsProvider>().serverUrl;
    });
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuracion')),
      body: AnimatedGradientBackground(
        Child: SafeArea(
          child: Consumer<SettingsProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.Accent),
                );
              }

              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'URL del backend',
                      style: TextStyle(
                        color: AppColors.TextPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _urlController,
                      decoration: const InputDecoration(
                        hintText: ApiConstants.DefaultBaseUrl,
                        prefixIcon: Icon(Icons.link),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.Warning.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.Warning.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Celular real (DNY NX9, etc.)',
                            style: TextStyle(
                              color: AppColors.Warning,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                            Text(
                            'NO uses 10.0.2.2 ni localhost.\n'
                            'La IP cambia si cambias de WiFi.\n'
                            'Mira la terminal del backend al iniciar\n'
                            'python app.py (ahi sale la URL).\n\n'
                            'En Windows: ipconfig → IPv4 de Wi-Fi',
                            style: TextStyle(
                              color: AppColors.TextPrimary,
                              fontSize: 12,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Solo emulador Android: http://10.0.2.2:5000',
                      style: TextStyle(
                        color: AppColors.TextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: provider.isSaving
                            ? null
                            : () => provider.SaveSettings(_urlController.text),
                        child: provider.isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Guardar y probar conexion'),
                      ),
                    ),
                    if (provider.connectionOk != null) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            provider.connectionOk! ? Icons.check_circle : Icons.error,
                            color: provider.connectionOk!
                                ? AppColors.Success
                                : AppColors.Danger,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              provider.message ?? '',
                              style: TextStyle(
                                color: provider.connectionOk!
                                    ? AppColors.Success
                                    : AppColors.Danger,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
