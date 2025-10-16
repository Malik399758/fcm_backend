/*

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/family_nav_screens/family_nav_controller.dart';

import '../../../components/common_widget/custom_back_button.dart';
import '../../../models/profile_model.dart';

class SentMessageScreen extends StatelessWidget {
  const SentMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Initialize the controller
    final FamilyNavController controller = Get.put(FamilyNavController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomBackButton(),
            Spacer(),
            BlackText(text: 'Messages',),
            SizedBox(width: 30,),
            Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * .05),
                ListView.builder(
                  shrinkWrap: true,
                  physics:
                  const NeverScrollableScrollPhysics(),
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
                      ? GreenButton(onTap: () {}, text: "Send Message")
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStream() {
    final FamilyNavController controller = Get.find<FamilyNavController>();

    return StreamBuilder<List<ProfileModel>>(
      stream: controller.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Obx(() {
              final isSelected = controller.isSelected(index);

              return GestureDetector(
                onTap: () => controller.toggleSelection(index),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          user.imageUrl ?? 'https://via.placeholder.com/150',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: BlackText(
                          text: user.name ?? "No Name",
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.greenColor
                                : AppColors.greyColor,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.greenColor
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/family_nav_screens/family_nav_controller.dart';
import 'package:loneliness/src/services/firebase_db_service/profile_service.dart';

import '../../../components/common_widget/custom_back_button.dart';
import '../../../models/profile_model.dart';

class SentMessageScreen extends StatelessWidget {
  const SentMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final FamilyNavController controller = Get.put(FamilyNavController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomBackButton(),
            const Spacer(),
            const BlackText(text: 'Messages'),
            const SizedBox(width: 30),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * .05),
                // ✅ Stream user list
                buildStream(),
                SizedBox(height: screenHeight * .03),
                Obx(
                      () => controller.hasSelection
                      ? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GreenButton(onTap: () {}, text: "Send Message"),
                      )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStream() {
    final FamilyNavController controller = Get.find<FamilyNavController>();
    final service = ProfileService();

    return StreamBuilder<List<ProfileModel?>>(
      stream: service.getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No users found.'));
        }

        final users = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];

            return Obx(() {
              final isSelected = controller.isSelected(index);

              return GestureDetector(
                onTap: () => controller.toggleSelection(index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.lightGreen : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: AssetImage(AppImages.user1),
                      ),
                      const SizedBox(width: 10),
                      BlackText(
                        text: user!.name ?? "No Name",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      Spacer(),
                      Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.greenColor
                                : AppColors.greyColor,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            height: 16,
                            width: 16,
                            decoration: BoxDecoration(
                              color: isSelected
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
        );
      },
    );
  }
}
