import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/home_nav_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    Get.put(HomeNavController());
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * .03),
                Row(
                  children: [
                    CustomBackButton(),
                    Spacer(),
                    BlackText(
                      text: "Notification",
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(height: screenHeight * .05),
                BlackText(
                  text: "Today",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                SizedBox(height: screenHeight * .03),
                NotificationWidget(
                  id: 0,
                  title: "New Video from Your Family!",
                  time: "2 m ago",
                  description:
                      "just shared a new video. Open the app to watch and stay connected!",
                ),
                NotificationWidget(
                  id: 1,
                  title: "Stay in Touch",
                  time: "2 m ago",
                  description:
                      "Don’t miss out on your family’s updates. Check your messages today!",
                ),
                BlackText(
                  text: "Yesterday",
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                SizedBox(height: screenHeight * .03),
                NotificationWidget(
                  id: 2,
                  title: "New Video from Your Family!",
                  time: "2 m ago",
                  description:
                      "just shared a new video. Open the app to watch and stay connected!",
                ),
                NotificationWidget(
                  id: 3,
                  title: "Stay in Touch",
                  time: "2 m ago",
                  description:
                      "Don’t miss out on your family’s updates. Check your messages today!",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final int id;

  const NotificationWidget({
    super.key,
    required this.id,
    required this.title,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final HomeNavController homeNavController = Get.find<HomeNavController>();
    // selection based on provided id
    return GestureDetector(
      onTap: () {
        homeNavController.selectedNotificationIndex.value = id;
      },
      child: Obx(() {
        final int selectedIdx =
            homeNavController.selectedNotificationIndex.value;
        final bool isSelected = selectedIdx == id;
        return Container(
          width: screenWidth,
          padding: EdgeInsets.all(screenWidth * .04),
          margin: EdgeInsets.only(bottom: screenHeight * .03),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.greenColor : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color:
                  isSelected ? AppColors.transparentColor : Color(0XFFE9E9E9),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: screenHeight * .056,
                width: screenWidth * .13,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.transparentColor
                            : Color(0XFFE9E9E9),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppImages.bell,
                    color: AppColors.greenColor,
                    width: screenWidth * .08,
                  ),
                ),
              ),

              SizedBox(width: screenWidth * .03),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlackText(
                      text: title,
                      textColor:
                          isSelected ? AppColors.whiteColor : Colors.black,
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: screenHeight * .01),
                    BlackText(
                      text: description,
                      textColor:
                          isSelected ? AppColors.whiteColor : Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              SizedBox(width: screenWidth * .01),
              BlackText(
                text: time,
                textColor: isSelected ? AppColors.whiteColor : Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        );
      }),
    );
  }
}
