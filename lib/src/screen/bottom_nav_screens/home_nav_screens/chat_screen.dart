import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(screenWidth * .06),
              child: Row(
                children: [
                  CustomBackButton(
                    color: AppColors.whiteColor,
                    borderColor: AppColors.transparentColor,
                  ),
                  SizedBox(width: screenWidth * .05),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * .07,
                        backgroundImage: AssetImage(AppImages.user1),
                      ),
                      SizedBox(width: screenWidth * .03),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlackText(
                            text: "Albert Flores",
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            textColor: AppColors.whiteColor,
                          ),
                          BlackText(
                            text: "Online",
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            textColor: AppColors.whiteColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
