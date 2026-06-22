import '../../domain/repositories/drowsiness_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._LocalDataSource);

  final SettingsLocalDataSource _LocalDataSource;

  @override
  Future<String> GetServerUrl() {
    return _LocalDataSource.GetServerUrl();
  }

  @override
  Future<void> SaveServerUrl(String Url) {
    return _LocalDataSource.SaveServerUrl(Url);
  }
}
