import '../../domain/entities/prediction_result.dart';
import '../../domain/repositories/drowsiness_repository.dart';
import '../datasources/drowsiness_remote_datasource.dart';

class DrowsinessRepositoryImpl implements DrowsinessRepository {
  const DrowsinessRepositoryImpl(this._RemoteDataSource);

  final DrowsinessRemoteDataSource _RemoteDataSource;

  @override
  Future<PredictionResult> AnalyzeVideo(String VideoPath) {
    return _RemoteDataSource.AnalyzeVideo(VideoPath);
  }

  @override
  Future<bool> CheckServerConnection() {
    return _RemoteDataSource.CheckConnection();
  }
}
