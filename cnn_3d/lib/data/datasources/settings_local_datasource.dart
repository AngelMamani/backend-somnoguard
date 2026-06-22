import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/api_constants.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._Preferences);

  final SharedPreferences _Preferences;

  Future<String> GetServerUrl() async {
    return _Preferences.getString(ApiConstants.ServerUrlKey) ??
        ApiConstants.DefaultBaseUrl;
  }

  Future<void> SaveServerUrl(String Url) async {
    await _Preferences.setString(ApiConstants.ServerUrlKey, Url.trim());
  }
}
