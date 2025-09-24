import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';

class FamilyNavView extends StatelessWidget {
  const FamilyNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    // Dummy data for 6 users
    final List<Map<String, String>> familyMembers = [
      {'name': 'Jane Cooper', 'image': AppImages.user1},
      {'name': 'John Doe', 'image': AppImages.user1}, // Assume user2 exists, else replace
      {'name': 'Kristin Watson', 'image': AppImages.user1},
      {'name': 'Cody Fisher', 'image': AppImages.user1},
      {'name': 'Savannah Nguyen', 'image': AppImages.user1},
    ];

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
                  physics: const NeverScrollableScrollPhysics(), // Disable inner scroll
                  itemCount: familyMembers.length, // 6 users
                  itemBuilder: (context, index) {
                    final member = familyMembers[index];
                    return Container(
                      width: screenWidth,
                      padding: EdgeInsets.all(screenWidth * .03),
                      margin: EdgeInsets.only(bottom: screenHeight * .02),
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
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
                              border: Border.all(color: AppColors.greenColor),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Container(
                                height: screenHeight * .028,
                                width: screenWidth * .04,
                                decoration: BoxDecoration(
                                  color: AppColors.greenColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: screenHeight * .03),
                GreenButton(onTap: (){}, text: "Create Now")
              ],
            ),
          ),
        ),
      ),
    );
  }
}