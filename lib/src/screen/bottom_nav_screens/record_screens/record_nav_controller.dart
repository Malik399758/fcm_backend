import 'dart:async';
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class RecordNavController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final AnimationController pulseController;

  final RxBool isRecording = false.obs;
  final RxBool hasStopped = false.obs;
  final Rx<Duration> elapsed = Duration.zero.obs;

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
