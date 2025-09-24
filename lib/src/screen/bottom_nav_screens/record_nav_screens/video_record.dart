import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'record_nav_controller.dart';
import 'package:camera/camera.dart';

class VideoRecordScreen extends GetView<RecordNavController> {
  const VideoRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: screenHeight * .050,
                  width: screenWidth * .11,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0XFFE9E9E9)),
                  ),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: SvgPicture.asset(
                      AppImages.microphone,
                      color: AppColors.blackColor,
                      width: screenWidth * .055,
                    ),
                  ),
                ),
              ],
            ),
            const Text("Video Record"),
            Container(
              height: screenHeight * .050,
              width: screenWidth * .11,
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
                  width: screenWidth * .045,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GetX<RecordNavController>(
          builder: (c) {
            c.initCamera();
            return Padding(
              padding:  EdgeInsets.symmetric(horizontal: screenWidth*.05,vertical: screenWidth*.08),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child:
                          c.cameraController != null &&
                                  c.cameraController!.value.isInitialized
                              ? CameraPreview(c.cameraController!)
                              : Container(color: Colors.black),
                    ),

                    // Top timer chip (visible only when recording)
                    if (c.isVideoRecording.value)
                      Positioned(
                        top: screenHeight * .08,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * .04,
                              vertical: screenHeight * .006,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              c.formattedTime,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: screenHeight * .06,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (c.isVideoRecording.value) {
                                await c.stopVideoRecording();
                                c.stopVideo();
                              } else {
                                await c.startVideoRecording();
                                c.startVideo();
                              }
                            },
                            child: _CircleIcon(
                              diameter: screenWidth * .16,
                              child: SvgPicture.asset(
                                c.isVideoRecording.value
                                    ? AppImages.stop
                                    : AppImages.videoIcon,
                                color:
                                    c.isVideoRecording.value
                                        ? Colors.red
                                        : Colors.black,
                                width: screenWidth * .085,
                              ),
                              background: Colors.white,
                            ),
                          ),
                          SizedBox(width: screenWidth * .10),
                          _CircleIcon(
                            diameter: screenWidth * .11,
                            child: SvgPicture.asset(
                              AppImages.flip,
                              color: Colors.black,
                              width: screenWidth * .06,
                            ),
                            onTap: () => c.flipCamera(),
                            background: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final double diameter;
  final Widget child;
  final VoidCallback? onTap;
  final Color? background;
  const _CircleIcon({
    required this.diameter,
    required this.child,
    this.onTap,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(diameter / 2),
        onTap: onTap,
        child: Container(
          height: diameter,
          width: diameter,
          decoration: BoxDecoration(
            color: background ?? AppColors.whiteColor,
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0XFFE9E9E9)),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
