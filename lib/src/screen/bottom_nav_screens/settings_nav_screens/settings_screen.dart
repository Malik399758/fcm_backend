import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsNavController());
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.03),

                // Settings Title
                Center(
                  child: BlackText(
                    text: 'Settings',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.blackColor,
                  ),
                ),

                SizedBox(height: screenHeight * 0.03),

                // Profile Information Card
                _buildProfileCard(
                  context,
                  controller,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Notification Section
                _buildSectionTitle('Notification', screenHeight),
                SizedBox(height: screenHeight * 0.015),

                _buildNotificationItem(
                  context,
                  controller,
                  AppImages.newMessages,
                  'New Messages',
                  'Get alerts for family videos & voice.',
                  controller.newMessagesEnabled,
                  controller.toggleNewMessages,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildNotificationItem(
                  context,
                  controller,
                  AppImages.reminder,
                  'Reminder Notifications',
                  'Reminders to check in with family',
                  controller.reminderNotificationsEnabled,
                  controller.toggleReminderNotifications,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Memory Cycles Section
                _buildSectionTitle('Memory Cycles', screenHeight),
                SizedBox(height: screenHeight * 0.015),

                _buildNavigationItem(
                  context,
                  controller,
                  AppImages.reminderFrequency,
                  'Reminder Frequency',
                  controller.reminderFrequency.value,
                  controller.navigateToReminderFrequency,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Subscription Section
                _buildSectionTitle('Subscription', screenHeight),
                SizedBox(height: screenHeight * 0.015),

                _buildNavigationItem(
                  context,
                  controller,
                  AppImages.subscription,
                  'Manage Subscription',
                  'View billing and subscription details',
                  controller.navigateToManageSubscription,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Support Section
                _buildSectionTitle('Support', screenHeight),
                SizedBox(height: screenHeight * 0.015),

                _buildNavigationItem(
                  context,
                  controller,
                  AppImages.help,
                  'Help & Support',
                  'Get help and contact support',
                  controller.navigateToHelpSupport,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.02),

                _buildNavigationItem(
                  context,
                  controller,
                  AppImages.privacyPolicy,
                  'Privacy policy',
                  'Read our privacy policy',
                  controller.navigateToPrivacyPolicy,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight * 0.03),

                // Account Section
                _buildSectionTitle('Account', screenHeight),
                SizedBox(height: screenHeight * 0.015),

                _buildSignOutItem(
                  context,
                  controller,
                  AppImages.signOut,
                  'Sign Out',
                  'Sign out of your account',
                  controller.signOut,
                  screenWidth,
                  screenHeight,
                ),

                SizedBox(height: screenHeight*.03,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(
    BuildContext context,
    SettingsNavController controller,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: controller.navigateToProfile,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              AppImages.profile,
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlackText(
                    text: 'Profile Information',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.whiteColor,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  BlackText(
                    text: 'Update your name, photo and details',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.whiteColor,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppImages.arrowRight,
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, double screenHeight) {
    return BlackText(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      textColor: AppColors.blackColor,
      textAlign: TextAlign.left,
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    SettingsNavController controller,
    String iconPath,
    String title,
    String subtitle,
    RxBool isEnabled,
    VoidCallback onToggle,
    double screenWidth,
    double screenHeight,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
      child: Row(
        children: [
          SvgPicture.asset(
            iconPath,
            width: screenWidth * 0.06,
            height: screenWidth * 0.06,
            color: AppColors.blackColor,
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlackText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.blackColor,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: screenHeight * 0.005),
                BlackText(
                  text: subtitle,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.greyColor,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          Obx(
            () => Switch(
              value: isEnabled.value,
              onChanged: (value) => onToggle(),
              inactiveThumbColor: AppColors.whiteColor,
              inactiveTrackColor: AppColors.blackColor.withOpacity(.3),
              activeTrackColor: AppColors.greenColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItem(
    BuildContext context,
    SettingsNavController controller,
    String iconPath,
    String title,
    String subtitle,
    VoidCallback onTap,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              color: AppColors.blackColor,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlackText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.blackColor,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  BlackText(
                    text: subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.greyColor,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            SvgPicture.asset(
              AppImages.arrowRight,
              width: screenWidth * 0.05,
              height: screenWidth * 0.05,
              color: AppColors.greyColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignOutItem(
    BuildContext context,
    SettingsNavController controller,
    String iconPath,
    String title,
    String subtitle,
    VoidCallback onTap,
    double screenWidth,
    double screenHeight,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
        child: Row(
          children: [
            SvgPicture.asset(
              iconPath,
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              color: AppColors.blackColor,
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlackText(
                    text: title,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.blackColor,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  BlackText(
                    text: subtitle,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.greyColor,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
