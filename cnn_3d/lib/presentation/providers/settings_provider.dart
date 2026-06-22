import 'package:flutter/foundation.dart';

import '../../domain/usecases/analyze_video_usecase.dart';
import '../../domain/usecases/settings_usecases.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    required GetServerUrlUseCase getServerUrlUseCase,
    required SaveServerUrlUseCase saveServerUrlUseCase,
    required CheckServerUseCase checkServerUseCase,
  })  : _getServerUrlUseCase = getServerUrlUseCase,
        _saveServerUrlUseCase = saveServerUrlUseCase,
        _checkServerUseCase = checkServerUseCase;

  final GetServerUrlUseCase _getServerUrlUseCase;
  final SaveServerUrlUseCase _saveServerUrlUseCase;
  final CheckServerUseCase _checkServerUseCase;

  String serverUrl = '';
  bool isLoading = true;
  bool isSaving = false;
  bool? connectionOk;
  String? message;

  Future<void> LoadSettings() async {
    isLoading = true;
    notifyListeners();

    serverUrl = await _getServerUrlUseCase.Execute();
    connectionOk = await _checkServerUseCase.Execute();

    isLoading = false;
    notifyListeners();
  }

  Future<void> SaveSettings(String url) async {
    isSaving = true;
    message = null;
    notifyListeners();

    await _saveServerUrlUseCase.Execute(url);
    serverUrl = url.trim();
    connectionOk = await _checkServerUseCase.Execute();

    isSaving = false;
    message = connectionOk == true
        ? 'Conexion exitosa con el backend.'
        : 'URL guardada, pero no se pudo conectar.';

    notifyListeners();
  }
}
