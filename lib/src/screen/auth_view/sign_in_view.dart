import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth*.05),
            child: Column(children: [
              SizedBox(height: screenHeight*.05),
              SvgPicture.asset(AppImages.appIcon,width: screenWidth*.2,),
              SizedBox(height: screenHeight*.05),
              BlackText(
                text: "Sign In",
                fontWeight: FontWeight.w500,
                fontSize: 24,
              )

            ],),
          ),
        ),
      )),
    );
  }
}
