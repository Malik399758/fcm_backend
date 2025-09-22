import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenHeight * .057,
      width: screenWidth * .12,
      decoration: BoxDecoration(
        color: AppColors.transparentColor,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0XFFE9E9E9)),
      ),
      child: IconButton(
        onPressed:(){Get.back();},
        icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
      ),
    );
  }
}
