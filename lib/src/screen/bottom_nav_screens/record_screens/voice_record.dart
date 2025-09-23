import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'dart:async';

class VoiceRecordScreen extends StatefulWidget {
  const VoiceRecordScreen({super.key});

  @override
  State<VoiceRecordScreen> createState() => _VoiceRecordScreenState();
}

class _VoiceRecordScreenState extends State<VoiceRecordScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rippleController;
  bool _isRecording = false;
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rippleController.dispose();
    super.dispose();
  }

  void _startRecording() {
    if (_isRecording) return;
    setState(() {
      _isRecording = true;
      _elapsed = Duration.zero;
    });
    _rippleController.repeat();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _elapsed += const Duration(seconds: 1);
      });
    });
    // Integrate actual audio record here if needed
  }

  void _stopRecording() {
    if (!_isRecording) return;
    setState(() {
      _isRecording = false;
    });
    _rippleController.stop();
    _timer?.cancel();
  }

  String get _formattedTime {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = (_elapsed.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (_elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final baseCircleSize = screenWidth * .45;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: screenHeight * .057,
              width: screenWidth * .12,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0XFFE9E9E9)),
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AppImages.videoIcon,
                  color: AppColors.blackColor,
                  width: screenWidth * .06,
                ),
              ),
            ),
            BlackText(
              text: "Voice Message",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            Container(
              height: screenHeight * .057,
              width: screenWidth * .12,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0XFFE9E9E9)),
              ),
              child: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(
                  AppImages.send,
                  color: AppColors.blackColor,
                  width: screenWidth * .05,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * .05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * .03,
                  vertical: screenHeight * .006,
                ),
                decoration: BoxDecoration(
                  color:
                      _isRecording
                          ? AppColors.orangeColor
                          : AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: BlackText(
                  text: _formattedTime,
                  fontSize: 12,
                  textColor:
                      _isRecording
                          ? AppColors.whiteColor
                          : AppColors.blackColor,
                ),
              ),
              SizedBox(height: screenHeight * .05),
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _rippleController,
                    builder: (context, _) {
                      final progress = _rippleController.value; // 0..1
                      return _GlossyCircle(
                        diameter: baseCircleSize,
                        isActive: _isRecording,
                        progress: progress,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onLongPressStart: (_) => _startRecording(),
                onLongPressEnd: (_) => _stopRecording(),
                child: AnimatedBuilder(
                  animation: _rippleController,
                  builder: (context, _) {
                    final double t = _rippleController.value; // 0..1
                    final double buttonSize = screenWidth * .20;
                    final List<double> offsets = [0.0, 0.33, 0.66];
                    return SizedBox(
                      height: buttonSize * 1.4,
                      width: buttonSize * 1.4,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (_isRecording)
                            ...offsets.map((offset) {
                              final double p = ((t + offset) % 1.0);
                              final double scale = 1.0 + p * 0.5;
                              final double opacity = (1.0 - p) * 0.35;
                              return Transform.scale(
                                scale: scale,
                                child: Container(
                                  height: buttonSize,
                                  width: buttonSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.greenColor.withOpacity(
                                      opacity,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.greenColor.withOpacity(
                                          opacity * 0.45,
                                        ),
                                        blurRadius: 16,
                                        spreadRadius: 1,
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
                              color:
                                  _isRecording
                                      ? AppColors.greenColor
                                      : AppColors.whiteColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.07),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _isRecording ? Icons.stop : Icons.mic,
                                color:
                                    _isRecording
                                        ? AppColors.whiteColor
                                        : AppColors.blackColor,
                                size: screenWidth * 0.08,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Removed legacy ripple widget (replaced with inline animation around mic button)

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
      duration: const Duration(milliseconds: 250),
      height: diameter,
      width: diameter,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.greenColor.withOpacity(.95),
            AppColors.greenColor.withOpacity(.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.greenColor.withOpacity(.40),
            blurRadius: isActive ? 35 : 18,
            spreadRadius: isActive ? 4 : 2,
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
    // Soft fill for depth
    final overlayPaint =
        Paint()
          ..shader = LinearGradient(
            colors: [
              Colors.white.withOpacity(.15),
              Colors.white.withOpacity(.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    // Moving glossy band (rotates continuously)
    final bandPaint =
        Paint()
          ..color = Colors.white.withOpacity(.65)
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * .06
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final radius = size.width / 2 - bandPaint.strokeWidth;
    final center = Offset(size.width / 2, size.height / 2);
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(progress * 6.283185307179586); // 2π
    canvas.translate(-center.dx, -center.dy);
    final startAngle = -0.6; // radians
    final sweepAngle = 1.2; // radians
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, startAngle, sweepAngle, false, bandPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
