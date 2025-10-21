import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class RecordNavController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController pulseController;

  // --- AUDIO RECORDING STATE ---
  final RxBool isAudioRecording = false.obs;
  final RxBool hasAudioStopped = false.obs;
  final Rx<Duration> audioElapsed = Duration.zero.obs;
  final RxString recordedAudioFilePath = ''.obs;
  final RxString audioErrorMessage = ''.obs;

  // --- VIDEO RECORDING STATE ---
  final RxBool isVideoRecording = false.obs;
  final RxBool hasVideoStopped = false.obs;
  final Rx<Duration> videoElapsed = Duration.zero.obs;
  final RxString recordedVideoFilePath = ''.obs;
  final RxString videoErrorMessage = ''.obs;

  // --- CAMERA STATE ---
  final RxBool isInitializingCamera = false.obs;
  final RxString cameraError = ''.obs;
  CameraController? cameraController;
  List<CameraDescription> _cameras = const [];

  // --- TIMERS ---
  Timer? _audioTimer;
  Timer? _videoTimer;

  // --- AUDIO RECORDER ---
  final Record _audioRecorder = Record();

  @override
  void onInit() {
    super.onInit();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    initCamera().then((_) {
      if (cameraError.isNotEmpty) {
        print("Camera error: ${cameraError.value}");
      } else {
        print("Camera initialized successfully");
      }
    });
  }

  Future<void> startAudioRecording() async {
    if (isAudioRecording.value) return;

    try {
      // Request mic permission
      final micStatus = await Permission.microphone.request();
      if (!micStatus.isGranted) {
        audioErrorMessage.value = 'Microphone permission denied';
        return;
      }

      bool hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        audioErrorMessage.value = 'Microphone permission denied';
        return;
      }

      await _audioRecorder.start(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        samplingRate: 44100,
      );

      isAudioRecording.value = true;
      hasAudioStopped.value = false;
      audioElapsed.value = Duration.zero;
      recordedAudioFilePath.value = '';
      audioErrorMessage.value = '';

      pulseController.repeat();

      _audioTimer?.cancel();
      _audioTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        audioElapsed.value = audioElapsed.value + const Duration(seconds: 1);
      });
    } catch (e) {
      audioErrorMessage.value = 'Failed to start audio recording: $e';
    }
  }

  Future<String?> stopAudioRecording() async {
    if (!isAudioRecording.value) return null;

    try {
      final path = await _audioRecorder.stop();

      isAudioRecording.value = false;
      hasAudioStopped.value = true;

      pulseController.stop();

      _audioTimer?.cancel();

      recordedAudioFilePath.value = path ?? '';

      return recordedAudioFilePath.value;
    } catch (e) {
      audioErrorMessage.value = 'Failed to stop audio recording: $e';
      return null;
    }
  }

  // ------------------------
  // VIDEO RECORDING METHODS
  // ------------------------

  Future<void> startVideoRecordingUI() async {
    if (isVideoRecording.value) return;

    isVideoRecording.value = true;
    hasVideoStopped.value = false;
    videoElapsed.value = Duration.zero;

    pulseController.repeat();

    _videoTimer?.cancel();
    _videoTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      videoElapsed.value = videoElapsed.value + const Duration(seconds: 1);
    });
  }

  Future<String?> startVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      videoErrorMessage.value = 'Camera not initialized';
      return null;
    }

    if (cameraController!.value.isRecordingVideo) {
      videoErrorMessage.value = 'Video already recording';
      return null;
    }

    try {
      await cameraController!.startVideoRecording();
      await startVideoRecordingUI();
      return null;
    } catch (e) {
      videoErrorMessage.value = 'Failed to start video recording: $e';
      return null;
    }
  }

  Future<String?> stopVideoRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) return null;

    try {
      final XFile file = await cameraController!.stopVideoRecording();
      recordedVideoFilePath.value = file.path;
      print("Video saved at: ${file.path}");

      await stopVideoRecordingUI();

      return file.path;
    } catch (e) {
      videoErrorMessage.value = 'Failed to stop video recording: $e';
      return null;
    }
  }

  Future<void> stopVideoRecordingUI() async {
    if (!isVideoRecording.value) return;

    isVideoRecording.value = false;
    hasVideoStopped.value = true;

    pulseController.stop();

    _videoTimer?.cancel();
  }


  Future<void> initCamera() async {
    if (isInitializingCamera.value) return;
    if (cameraController != null && cameraController!.value.isInitialized) return;

    isInitializingCamera.value = true;
    cameraError.value = '';

    try {
      final camStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (!camStatus.isGranted || !micStatus.isGranted) {
        cameraError.value = 'Camera/Microphone permission denied';
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
    if (isInitializingCamera.value) return;

    try {
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

  String get formattedAudioTime {
    final d = audioElapsed.value;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  String get formattedVideoTime {
    final d = videoElapsed.value;
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = (d.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  double get progress => pulseController.value;

  @override
  void onClose() {
    _audioTimer?.cancel();
    _videoTimer?.cancel();

    pulseController.dispose();
    cameraController?.dispose();
    _audioRecorder.dispose();

    super.onClose();
  }
}
