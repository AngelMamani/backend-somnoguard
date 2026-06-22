import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'presentation/pages/splash_page.dart';
import 'presentation/providers/monitor_provider.dart';
import 'presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InjectionContainer.Init();
  runApp(const SomnoGuardApp());
}

class SomnoGuardApp extends StatelessWidget {
  const SomnoGuardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.CreateMonitorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => InjectionContainer.CreateSettingsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'SomnoGuard',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.GetTheme(),
        home: const SplashPage(),
      ),
    );
  }
}
