import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../models/prediction_result_model.dart';
import 'settings_local_datasource.dart';

class DrowsinessRemoteDataSource {
  DrowsinessRemoteDataSource(this._SettingsLocal);

  final SettingsLocalDataSource _SettingsLocal;

  Future<PredictionResultModel> AnalyzeVideo(String VideoPath) async {
    final String BaseUrl = await _SettingsLocal.GetServerUrl();
    final Uri Url = Uri.parse('$BaseUrl${ApiConstants.PredictEndpoint}');
    final File VideoFile = File(VideoPath);

    if (!VideoFile.existsSync()) {
      throw Exception('No se encontro el video grabado.');
    }

    final http.MultipartRequest Request = http.MultipartRequest('POST', Url);
    Request.files.add(
      await http.MultipartFile.fromPath('video', VideoPath),
    );

    final http.StreamedResponse StreamedResponse = await Request.send()
        .timeout(const Duration(minutes: 3));

    final String Body = await StreamedResponse.stream.bytesToString();

    if (StreamedResponse.statusCode != 200) {
      final Map<String, dynamic> ErrorJson = jsonDecode(Body) as Map<String, dynamic>;
      throw Exception(ErrorJson['error']?.toString() ?? 'Error del servidor');
    }

    final Map<String, dynamic> Json = jsonDecode(Body) as Map<String, dynamic>;
    return PredictionResultModel.FromJson(Json);
  }

  Future<bool> CheckConnection() async {
    try {
      final String BaseUrl = await _SettingsLocal.GetServerUrl();
      final Uri Url = Uri.parse('$BaseUrl${ApiConstants.HealthEndpoint}');
      final http.Response Response = await http.get(Url).timeout(
        const Duration(seconds: 5),
      );
      return Response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
