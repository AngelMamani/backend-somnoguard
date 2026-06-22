import '../entities/prediction_result.dart';
import '../repositories/drowsiness_repository.dart';

class AnalyzeVideoUseCase {
  const AnalyzeVideoUseCase(this._Repository);

  final DrowsinessRepository _Repository;

  Future<PredictionResult> Execute(String VideoPath) {
    return _Repository.AnalyzeVideo(VideoPath);
  }
}

class CheckServerUseCase {
  const CheckServerUseCase(this._Repository);

  final DrowsinessRepository _Repository;

  Future<bool> Execute() {
    return _Repository.CheckServerConnection();
  }
}
