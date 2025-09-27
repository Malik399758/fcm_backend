import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            const CustomBackButton(),
            const Spacer(),
            const BlackText(
              text: 'Privacy Policy',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: screenHeight*.03),

              BlackText(
                text: "Cancelation Policy",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: screenHeight*.02),
              BlackText(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                textColor: AppColors.greyColor,
              ),
              SizedBox(height: screenHeight*.03),
              BlackText(
                text: "Terms & Condition",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: screenHeight*.02),
              BlackText(
                text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\n"
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et.",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.start,
                textColor: AppColors.greyColor,
              ),
              SizedBox(height: screenHeight*.05),

          ],),
        ),
      )),
    );
  }
}

