import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/constants/api_constants.dart';
import '../../domain/entities/prediction_result.dart';
import '../../domain/usecases/analyze_video_usecase.dart';

enum MonitorStatus { idle, initializing, monitoring, analyzing, error }

class MonitorProvider extends ChangeNotifier {
  MonitorProvider({
    required AnalyzeVideoUseCase analyzeVideoUseCase,
    required CheckServerUseCase checkServerUseCase,
  })  : _analyzeVideoUseCase = analyzeVideoUseCase,
        _checkServerUseCase = checkServerUseCase;

  final AnalyzeVideoUseCase _analyzeVideoUseCase;
  final CheckServerUseCase _checkServerUseCase;

  CameraController? cameraController;
  MonitorStatus status = MonitorStatus.idle;
  PredictionResult lastResult = PredictionResult.Initial();
  String? errorMessage;
  bool serverOnline = false;
  int analysisCount = 0;

  Timer? _monitorTimer;
  bool _isBusy = false;

  Future<void> InitializeCamera() async {
    if (status == MonitorStatus.initializing) return;

    status = MonitorStatus.initializing;
    errorMessage = null;
    notifyListeners();

    try {
      final PermissionStatus cameraPermission = await Permission.camera.request();
      final PermissionStatus micPermission = await Permission.microphone.request();

      if (cameraPermission.isDenied || cameraPermission.isPermanentlyDenied) {
        throw Exception('Se requiere permiso de camara.');
      }

      if (micPermission.isDenied) {
        throw Exception('Se requiere permiso de microfono para grabar video.');
      }

      serverOnline = await _checkServerUseCase.Execute();

      final List<CameraDescription> cameras = await availableCameras();
      final CameraDescription frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      await cameraController?.dispose();

      cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await cameraController!.initialize();

      status = MonitorStatus.idle;
      notifyListeners();
    } catch (error) {
      status = MonitorStatus.error;
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> StartMonitoring() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      await InitializeCamera();
    }

    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    status = MonitorStatus.monitoring;
    notifyListeners();

    await _RunAnalysisCycle();

    _monitorTimer?.cancel();
    _monitorTimer = Timer.periodic(
      const Duration(seconds: ApiConstants.AnalysisIntervalSeconds),
      (_) => _RunAnalysisCycle(),
    );
  }

  Future<void> StopMonitoring() async {
    _monitorTimer?.cancel();
    _monitorTimer = null;
    status = MonitorStatus.idle;
    notifyListeners();
  }

  Future<void> AnalyzeOnce() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      await InitializeCamera();
    }
    await _RunAnalysisCycle();
  }

  Future<void> _RunAnalysisCycle() async {
    if (_isBusy || cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    _isBusy = true;
    status = MonitorStatus.analyzing;
    errorMessage = null;
    notifyListeners();

    try {
      serverOnline = await _checkServerUseCase.Execute();

      if (!serverOnline) {
        throw Exception('Backend no disponible. Revisa la URL en ajustes.');
      }

      await cameraController!.startVideoRecording();
      await Future.delayed(
        const Duration(seconds: ApiConstants.ClipDurationSeconds),
      );
      final XFile videoFile = await cameraController!.stopVideoRecording();

      final PredictionResult result = await _analyzeVideoUseCase.Execute(videoFile.path);

      lastResult = result;
      analysisCount++;
      status = MonitorStatus.monitoring;
    } catch (error) {
      status = MonitorStatus.error;
      errorMessage = error.toString().replaceFirst('Exception: ', '');
    } finally {
      _isBusy = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    cameraController?.dispose();
    super.dispose();
  }
}
