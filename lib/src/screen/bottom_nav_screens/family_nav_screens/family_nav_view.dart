import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';

class FamilyNavView extends StatelessWidget {
  const FamilyNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*.05),
              BlackText(
                text: "My Families",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: screenHeight*.006),
              BlackText(
                text: "Create Group",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.greyColor,
              ),
              SizedBox(height: screenHeight*.03),
              BlackText(
                text: "Family members",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: screenHeight*.03),
              Container(
                width: screenWidth,
                color: Colors.red,
                height: 80,
                child: Row(children: [

                  
                ],),
              )
          ],),
        ),
      )),
    );
  }
}
