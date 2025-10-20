import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/family_nav_screens/family_nav_controller.dart';

import '../../../components/app_colors_images/app_images.dart';
import '../../../models/profile_model.dart';
import '../../../services/firebase_db_service/profile_service.dart';

class FamilyNavView extends StatefulWidget {
  const FamilyNavView({super.key});

  @override
  State<FamilyNavView> createState() => _FamilyNavViewState();
}

class _FamilyNavViewState extends State<FamilyNavView> {
  List<ProfileModel?> allUsers = [];
  Set<int> selectedIndexes = {};

  Future<String?> _showGroupNameDialog(BuildContext context) async {
    TextEditingController nameController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Group Name"),
          content: TextField(controller: nameController),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, nameController.text),
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }


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
                /*ListView.builder(
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
                ),*/
                _buildUserStream(),
                SizedBox(height: screenHeight * .03),
                selectedIndexes.isNotEmpty
                    ? GreenButton(
                  onTap: () async {
                    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

                    final selectedUserIds = selectedIndexes.map((i) => allUsers[i]!.uid).toList();

                    // Add current user if not already included
                    if (!selectedUserIds.contains(currentUserId)) {
                      selectedUserIds.add(currentUserId);
                    }

                    if (selectedUserIds.isEmpty) {
                      Get.snackbar("Error", "Select at least one member");
                      return;
                    }

                    final groupName = await _showGroupNameDialog(context);
                    if (groupName == null || groupName.isEmpty) return;

                    await controller.createGroup(groupName, selectedUserIds);

                    setState(() {
                      selectedIndexes.clear();
                    });
                  },

                  text: "Create Now",
                )
                    : const SizedBox.shrink()


              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserStream() {
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

        allUsers = snapshot.data!;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            final user = allUsers[index];
            final isSelected = selectedIndexes.contains(index);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedIndexes.remove(index);
                  } else {
                    selectedIndexes.add(index);
                  }
                });
              },
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
                    const Spacer(),
                    Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.greenColor : AppColors.greyColor,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.greenColor : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
