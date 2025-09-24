import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/family_nav_screens/family_nav_controller.dart';

class FamilyNavView extends StatelessWidget {
  const FamilyNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Initialize the controller
    final FamilyNavController controller = Get.put(FamilyNavController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * .05),
                BlackText(
                  text: "My Families",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: screenHeight * .006),
                BlackText(
                  text: "Create Group",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.greyColor,
                ),
                SizedBox(height: screenHeight * .03),
                BlackText(
                  text: "Family members",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                SizedBox(height: screenHeight * .03),
                ListView.builder(
                  shrinkWrap: true, // To fit inside SingleChildScrollView
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable inner scroll
                  itemCount: controller.familyMembers.length,
                  itemBuilder: (context, index) {
                    final member = controller.familyMembers[index];

                    return Obx(() {
                      final isSelected = controller.isSelected(index);

                      return GestureDetector(
                        onTap: () => controller.toggleSelection(index),
                        child: Container(
                          width: screenWidth,
                          padding: EdgeInsets.all(screenWidth * .03),
                          margin: EdgeInsets.only(bottom: screenHeight * .02),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? AppColors.lightGreen
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: screenWidth * .06,
                                backgroundImage: AssetImage(member['image']!),
                              ),
                              SizedBox(width: screenWidth * .03),
                              BlackText(
                                text: member['name']!,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              Container(
                                height: screenHeight * .04,
                                width: screenWidth * .07,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? AppColors.greenColor
                                            : AppColors.greyColor,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Container(
                                    height: screenHeight * .028,
                                    width: screenWidth * .04,
                                    decoration: BoxDecoration(
                                      color:
                                          isSelected
                                              ? AppColors.greenColor
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
                SizedBox(height: screenHeight * .03),
                Obx(
                  () =>
                      controller.hasSelection
                          ? GreenButton(onTap: () {}, text: "Create Now")
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
