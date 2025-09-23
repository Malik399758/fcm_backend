import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';

class CustomBackButton extends StatelessWidget {

  final Color? color;
  final Color? borderColor;

  const CustomBackButton({super.key,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenHeight * .057,
      width: screenWidth * .12,
      decoration: BoxDecoration(
        color: color ?? AppColors.transparentColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor ?? Color(0XFFE9E9E9)),
      ),
      child: IconButton(
        onPressed:(){Get.back();},
        icon: Icon(Icons.arrow_back, color: AppColors.blackColor),
      ),
    );
  }
}
