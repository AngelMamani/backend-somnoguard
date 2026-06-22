import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/drowsiness_remote_datasource.dart';
import '../../data/datasources/settings_local_datasource.dart';
import '../../data/repositories/drowsiness_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/drowsiness_repository.dart';
import '../../domain/usecases/analyze_video_usecase.dart';
import '../../domain/usecases/settings_usecases.dart';
import '../../presentation/providers/monitor_provider.dart';
import '../../presentation/providers/settings_provider.dart';

class InjectionContainer {
  static late AnalyzeVideoUseCase analyzeVideoUseCase;
  static late CheckServerUseCase checkServerUseCase;
  static late GetServerUrlUseCase getServerUrlUseCase;
  static late SaveServerUrlUseCase saveServerUrlUseCase;

  static Future<void> Init() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final SettingsLocalDataSource settingsLocal = SettingsLocalDataSource(preferences);
    final DrowsinessRemoteDataSource remote = DrowsinessRemoteDataSource(settingsLocal);

    final DrowsinessRepository drowsinessRepo = DrowsinessRepositoryImpl(remote);
    final SettingsRepository settingsRepo = SettingsRepositoryImpl(settingsLocal);

    analyzeVideoUseCase = AnalyzeVideoUseCase(drowsinessRepo);
    checkServerUseCase = CheckServerUseCase(drowsinessRepo);
    getServerUrlUseCase = GetServerUrlUseCase(settingsRepo);
    saveServerUrlUseCase = SaveServerUrlUseCase(settingsRepo);
  }

  static MonitorProvider CreateMonitorProvider() {
    return MonitorProvider(
      analyzeVideoUseCase: analyzeVideoUseCase,
      checkServerUseCase: checkServerUseCase,
    );
  }

  static SettingsProvider CreateSettingsProvider() {
    return SettingsProvider(
      getServerUrlUseCase: getServerUrlUseCase,
      saveServerUrlUseCase: saveServerUrlUseCase,
      checkServerUseCase: checkServerUseCase,
    );
  }
}
