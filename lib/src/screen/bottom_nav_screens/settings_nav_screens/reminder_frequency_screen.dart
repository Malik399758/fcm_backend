import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/reminder_controller.dart';
import 'package:loneliness/src/routes/app_routes.dart';

class ReminderFrequencyScreen extends StatelessWidget {
  const ReminderFrequencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.put(ReminderController());
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            CustomBackButton(),
            Spacer(),
            BlackText(
              text: 'Memory Cycles',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            Spacer(),
          ],
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Row(
                children: [
                  Expanded(
                    child: _PresetCard(
                      index: 0,
                      title: '30 Days',
                      subtitle: 'Short-term\nmemory',
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.04),
                  Expanded(
                    child: _PresetCard(
                      index: 1,
                      title: '60 Days',
                      subtitle: 'Short-term\nmemory',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              _CustomDateCard(
                onTap: () => Get.toNamed(AppRoutes.reminderCalendarScreen),
              ),
              const Spacer(),
              GreenButton(
                text: 'Save Memory Cycle',
                onTap: controller.save,
                width: screenWidth,
              ),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }
}

class _PresetCard extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  const _PresetCard({
    required this.index,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final ReminderController controller = Get.find<ReminderController>();
    final double screenHeight = MediaQuery.of(context).size.height;
    return Obx(() {
      final bool selected = controller.selectedPresetIndex.value == index;
      return GestureDetector(
        onTap: () => controller.selectPreset(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.024),
          decoration: BoxDecoration(
            color: selected ? AppColors.greenColor : AppColors.transparentColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppColors.greenColor : AppColors.lightGrey,
            ),
          ),
          child: Column(
            children: [
              const Icon(Icons.access_time, color: Colors.black),
              SizedBox(height: screenHeight * 0.01),
              BlackText(
                text: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor:
                    selected ? AppColors.whiteColor : AppColors.blackColor,
              ),
              SizedBox(height: screenHeight * 0.005),
              BlackText(
                text: subtitle,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor:
                    selected ? AppColors.whiteColor : AppColors.greyColor,
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _CustomDateCard extends StatelessWidget {
  final VoidCallback onTap;
  const _CustomDateCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
        decoration: BoxDecoration(
          color: AppColors.transparentColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Column(
          children: const [
            Icon(Icons.calendar_today, color: Colors.black),
            SizedBox(height: 8),
            BlackText(
              text: 'Custom Date',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            SizedBox(height: 4),
            BlackText(
              text: 'Personalized duration',
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}
