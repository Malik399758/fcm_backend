
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/models/profile_model.dart';
import 'package:loneliness/src/services/firebase_db_service/message_service.dart';
import 'package:loneliness/src/services/firebase_db_service/profile_service.dart';

import '../../../components/common_widget/custom_back_button.dart';

class SentMessageScreen extends StatefulWidget {
  final String mediaFilePath;
  final String mediaType;

  const SentMessageScreen({super.key, required this.mediaFilePath,required this.mediaType});

  @override
  State<SentMessageScreen> createState() => _SentMessageScreenState();
}

class _SentMessageScreenState extends State<SentMessageScreen> {
  List<ProfileModel?> allUsers = [];
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CustomBackButton(),
            Spacer(),
            BlackText(text: 'Messages'),
            SizedBox(width: 30),
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
                _buildUserStream(),
                SizedBox(height: screenHeight * .03),
                if (selectedIndexes.isNotEmpty)
                  GreenButton(
                    onTap: _sendMediaMessageToSelectedUsers,
                    text: "Send Message",
                  ),
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

  Future<void> _sendMediaMessageToSelectedUsers() async {
    final file = File(widget.mediaFilePath);

    if (!file.existsSync()) {
      Get.snackbar("Error", "${widget.mediaType.capitalizeFirst} file not found");
      return;
    }

    final chatService = ChatService();

    Get.dialog(
      Center(child: CircularProgressIndicator(color: CupertinoColors.systemTeal,)),
      barrierDismissible: false,
    );

    try {
      final selectedUsers = selectedIndexes.map((i) => allUsers[i]).toList();

      for (final user in selectedUsers) {
        if (user?.uid != null) {
          await chatService.sendMediaMessage(
            receiverId: user!.uid,
            file: file,
            mediaType: widget.mediaType,
          );
        }
      }
      Get.back(); // dismiss loading dialog
      Get.back(); // go back to previous screen
      Get.snackbar("Success", "${widget.mediaType.capitalizeFirst} message sent to ${selectedUsers.length} users");
    } catch (e) {
      Get.back();
      Get.snackbar("Error", "Failed to send message: $e");
    }
  }


}
