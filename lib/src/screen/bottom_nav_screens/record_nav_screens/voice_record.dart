
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/sent_message_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/video_record.dart';
import 'record_nav_controller.dart';

class VoiceRecordScreen extends GetView<RecordNavController> {
  const VoiceRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final baseCircleSize = screenWidth * .48;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Tooltip(
              message: 'Go to Video Record',
              child: GestureDetector(
                onTap: () => Get.to(const VideoRecordScreen()),
                child: Container(
                  height: screenHeight * .057,
                  width: screenWidth * .12,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0XFFE9E9E9)),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppImages.videoIcon,
                      color: AppColors.blackColor,
                      width: screenWidth * .06,
                    ),
                  ),
                ),
              ),
            ),
            const BlackText(
              text: "Voice Message",
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            Tooltip(
              message: 'Go to Sent Messages',
              child: Container(
                height: screenHeight * .057,
                width: screenWidth * .12,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0XFFE9E9E9)),
                ),
                child: IconButton(
                  onPressed: () {
                    //Get.to(() => const SentMessageScreen());
                    Get.to(() => SentMessageScreen(mediaFilePath: controller.recordedAudioFilePath.value,mediaType: 'audio',));
                  },
                  icon: SvgPicture.asset(
                    AppImages.send,
                    color: AppColors.blackColor,
                    width: screenWidth * .05,
                  ),
                  splashRadius: screenWidth * .10,
                  tooltip: 'Sent Messages',
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GetX<RecordNavController>(
          builder: (c) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * .08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * .04,
                      vertical: screenHeight * .008,
                    ),
                    decoration: BoxDecoration(
                      color: c.isAudioRecording.value ? Colors.red : AppColors.lightGrey,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: c.isAudioRecording.value
                          ? [
                        BoxShadow(
                          color: Colors.redAccent.withOpacity(0.6),
                          blurRadius: 12,
                          spreadRadius: 2,
                        )
                      ]
                          : null,
                    ),
                    child: BlackText(
                      text: c.isAudioRecording.value ? c.formattedAudioTime : "00:00:00",
                      fontSize: 14,
                      textColor: c.isAudioRecording.value ? AppColors.whiteColor : AppColors.blackColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * .07),
                  Expanded(
                    child: Center(
                      child: AnimatedBuilder(
                        animation: c.pulseController,
                        builder: (context, _) {
                          final progress = c.progress; // 0..1
                          return _GlossyCircle(
                            diameter: baseCircleSize,
                            isActive: c.isAudioRecording.value,
                            progress: progress,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onLongPressStart: (_) => c.startAudioRecording(),
                    onLongPressEnd: (_) => c.stopAudioRecording(),
                    child: AnimatedBuilder(
                      animation: c.pulseController,
                      builder: (context, _) {
                        final t = c.progress;
                        final buttonSize = screenWidth * .22;
                        final List<double> offsets = [0.0, 0.33, 0.66];
                        return SizedBox(
                          height: buttonSize * 1.4,
                          width: buttonSize * 1.4,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (c.isAudioRecording.value)
                                ...offsets.map((offset) {
                                  final p = ((t + offset) % 1.0);
                                  final scale = 1.0 + p * 0.7;
                                  final opacity = (1.0 - p) * 0.3;
                                  return Transform.scale(
                                    scale: scale,
                                    child: Container(
                                      height: buttonSize,
                                      width: buttonSize,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.greenColor.withOpacity(opacity),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.greenColor.withOpacity(opacity * 0.5),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              Container(
                                height: buttonSize,
                                width: buttonSize,
                                decoration: BoxDecoration(
                                  color: c.isAudioRecording.value ? AppColors.greenColor : AppColors.whiteColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    c.isAudioRecording.value ? AppImages.delete : AppImages.microphone,
                                    width: screenWidth * 0.07,
                                    color: c.isAudioRecording.value ? AppColors.whiteColor : AppColors.blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * .10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Glossy circle around the record button
class _GlossyCircle extends StatelessWidget {
  final double diameter;
  final bool isActive;
  final double progress;

  const _GlossyCircle({
    required this.diameter,
    required this.isActive,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.greenColor.withOpacity(.95),
            AppColors.greenColor.withOpacity(.80),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withOpacity(.45),
            blurRadius: isActive ? 40 : 20,
            spreadRadius: isActive ? 5 : 3,
          ),
        ],
      ),
      child: CustomPaint(painter: _GlossPainter(progress: progress)),
    );
  }
}

class _GlossPainter extends CustomPainter {
  final double progress;
  _GlossPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Soft white overlay for depth
    final overlayPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.white.withOpacity(.15),
          Colors.white.withOpacity(.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Rotating glossy band
    final bandPaint = Paint()
      ..color = Colors.white.withOpacity(.65)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * .06
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final radius = size.width / 2 - bandPaint.strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 2 * 3.1415926535);
    canvas.translate(-center.dx, -center.dy);

    const startAngle = -0.6;
    const sweepAngle = 1.2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, bandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
