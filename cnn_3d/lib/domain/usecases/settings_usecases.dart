import '../repositories/drowsiness_repository.dart';

class GetServerUrlUseCase {
  const GetServerUrlUseCase(this._Repository);

  final SettingsRepository _Repository;

  Future<String> Execute() {
    return _Repository.GetServerUrl();
  }
}

class SaveServerUrlUseCase {
  const SaveServerUrlUseCase(this._Repository);

  final SettingsRepository _Repository;

  Future<void> Execute(String Url) {
    return _Repository.SaveServerUrl(Url);
  }
}
