import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

class RecordNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController pulseController;

  final RxBool isRecording = false.obs;
  final RxBool hasStopped = false.obs;
  final Rx<Duration> elapsed = Duration.zero.obs;
  // Video recording state
  final RxBool isVideoRecording = false.obs;
  final RxBool hasVideoStopped = false.obs;
  final RxBool isInitializingCamera = false.obs;
  final RxString cameraError = ''.obs;
  CameraController? cameraController;
  List<CameraDescription> _cameras = const [];

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  void startRecording() {
    if (isRecording.value) return;
    isRecording.value = true;
    hasStopped.value = false;
    elapsed.value = Duration.zero;
    pulseController.repeat();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value = elapsed.value + const Duration(seconds: 1);
    });
  }

  void stopRecording() {
    if (!isRecording.value) return;
    isRecording.value = false;
    hasStopped.value = true;
    pulseController.stop();
    _timer?.cancel();
  }

  void startVideo() {
    if (isVideoRecording.value) return;
    isVideoRecording.value = true;
    hasVideoStopped.value = false;
    elapsed.value = Duration.zero;
    pulseController.repeat();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      elapsed.value = elapsed.value + const Duration(seconds: 1);
    });
  }

  void stopVideo() {
    if (!isVideoRecording.value) return;
    isVideoRecording.value = false;
    hasVideoStopped.value = true;
    pulseController.stop();
    _timer?.cancel();
  }

  Future<void> initCamera() async {
    if (isInitializingCamera.value) return;
    if (cameraController != null && cameraController!.value.isInitialized)
      return;
    isInitializingCamera.value = true;
    cameraError.value = '';
    try {
      final camStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();
      if (!camStatus.isGranted || !micStatus.isGranted) {
        cameraError.value = 'Camera/Microphone permission denied';
        isInitializingCamera.value = false;
        return;
      }
      _cameras = await availableCameras();
      final CameraDescription backCam = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );
      cameraController = CameraController(
        backCam,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await cameraController!.initialize();
    } catch (e) {
      cameraError.value = e.toString();
    } finally {
      isInitializingCamera.value = false;
    }
  }

  Future<void> flipCamera() async {
    try {
      if (isInitializingCamera.value) return;
      if (_cameras.isEmpty) {
        _cameras = await availableCameras();
      }
      final current = cameraController?.description;
      if (current == null) return;
      final idx = _cameras.indexOf(current);
      final next = _cameras[(idx + 1) % _cameras.length];

      isInitializingCamera.value = true;
      final prev = cameraController;
      cameraController = null;
      update();
      await prev?.dispose();
      await Future.delayed(const Duration(milliseconds: 120));

      final newController = CameraController(
        next,
        ResolutionPreset.high,
        enableAudio: true,
      );
      await newController.initialize();
      cameraController = newController;
      update();
    } catch (e) {
      cameraError.value = e.toString();
    } finally {
      isInitializingCamera.value = false;
    }
  }

  Future<void> startVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized)
      return;
    if (cameraController!.value.isRecordingVideo) return;
    await cameraController!.startVideoRecording();
  }

  Future<void> stopVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo)
      return;
    await cameraController!.stopVideoRecording();
  }

  String get formattedTime {
    final d = elapsed.value;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  double get progress => pulseController.value;

  @override
  void onClose() {
    _timer?.cancel();
    pulseController.dispose();
    super.onClose();
  }
}
