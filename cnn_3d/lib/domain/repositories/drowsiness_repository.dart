import '../entities/prediction_result.dart';

abstract class DrowsinessRepository {
  Future<PredictionResult> AnalyzeVideo(String VideoPath);
  Future<bool> CheckServerConnection();
}

abstract class SettingsRepository {
  Future<String> GetServerUrl();
  Future<void> SaveServerUrl(String Url);
}
