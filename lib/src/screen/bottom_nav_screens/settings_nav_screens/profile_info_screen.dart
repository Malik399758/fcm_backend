import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsNavController controller = Get.find<SettingsNavController>();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const CustomBackButton(),
            const Spacer(),
            const BlackText(
              text: 'Your Profile',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Avatar + edit badge
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() {
                      final avatar = controller.avatarFile.value;
                      return CircleAvatar(
                        radius: screenWidth * 0.16,
                        backgroundColor: AppColors.lightGrey,
                        backgroundImage:
                            avatar != null ? Image.file(avatar).image : null,
                      );
                    }),
                    GestureDetector(
                      onTap: () => _showAvatarSheet(context, controller),
                      child: Container(
                        width: screenWidth * 0.11,
                        height: screenWidth * 0.11,
                        decoration: BoxDecoration(
                          color: AppColors.greenColor,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 3,
                          ),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.camera,
                            width: screenWidth * 0.06,
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              const BlackText(
                text: 'Name',
                textAlign: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.nameController,
                hintText: 'Salman',
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Phone Number',
                textAlign: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.phoneController,
                hintText: '0000000',
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Email',
                textAlign: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.emailController,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'DOB',
                textAlign: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              TextFieldWidget(
                controller: controller.dobController,
                hintText: 'DD/MM/YY',
                keyboardType: TextInputType.datetime,
                suffixIcon: Icon(
                  Icons.calendar_today,
                  color: AppColors.greyColor,
                  size: screenWidth * 0.05,
                ),
              ),

              SizedBox(height: screenHeight * 0.02),
              const BlackText(
                text: 'Gender',
                textAlign: TextAlign.left,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: screenHeight * 0.008),
              _GenderDropdown(controller: controller),

              SizedBox(height: screenHeight * 0.04),
              GreenButton(text: 'Upload Now', onTap: controller.submitProfile),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  void _showAvatarSheet(
    BuildContext context,
    SettingsNavController controller,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.05,
          vertical: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 14),
            const BlackText(
              text: 'Change Avatar',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const SizedBox(height: 16),
            _AvatarActionTile(
              icon: AppImages.camera,
              title: 'Take photo',
              onTap: () {
                Get.back();
                controller.takePhoto();
              },
            ),
            const SizedBox(height: 12),
            _AvatarActionTile(
              icon: AppImages.download,
              title: 'From Gallery',
              onTap: () {
                Get.back();
                controller.pickFromGallery();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final SettingsNavController controller;
  const _GenderDropdown({required this.controller});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value:
                controller.selectedGender.value.isEmpty
                    ? null
                    : controller.selectedGender.value,
            hint: const Text('Select'),
            isExpanded: true,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.greyColor,
              size: screenWidth * 0.06,
            ),
            items: const [
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              if (value != null) controller.setGender(value);
            },
          ),
        ),
      );
    });
  }
}

class _AvatarActionTile extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;
  const _AvatarActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: screenWidth * 0.08,
              color: AppColors.greenColor,
            ),
            const SizedBox(width: 10),
            BlackText(
              text: title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              textColor: AppColors.blackColor,
            ),
          ],
        ),
      ),
    );
  }
}
