import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth*.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            SizedBox(height: screenHeight*.03),
            Center(child: SvgPicture.asset(AppImages.appIcon,width: screenWidth*.2,)),
            SizedBox(height: screenHeight*.05),
            Center(
              child: BlackText(
                text: "Sign In",
                fontWeight: FontWeight.w500,
                fontSize: 24,
              ),
            ),
            SizedBox(height: screenHeight*.03),
            Center(
              child: BlackText(
                text: "Hi! Welcome back, you’ve been missed ",
                fontWeight: FontWeight.w400,
                fontSize: 12,
                textColor: AppColors.greyColor,
              ),
            ),
              SizedBox(height: screenHeight*.03),
              BlackText(
                text: "Name",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: screenHeight*.006),
              TextFieldWidget(controller: emailController, hintText: "your@gmail.com"),
              SizedBox(height: screenHeight*.03),
              BlackText(
                text: "Password",
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              SizedBox(height: screenHeight*.006),
              TextFieldWidget(controller: emailController, hintText: "****************",suffixIcon: Icon(Icons.remove_red_eye_outlined),),
              SizedBox(height: screenHeight*.01),
              Align(
                alignment: Alignment.bottomRight,
                child: BlackText(
                  onTap: (){},
                  text: "Forgot Password?",
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.greenColor,
                ),
              ),
              SizedBox(height: screenHeight*.03),
              GreenButton(onTap: (){}, text: "Sign In")



          ],),
        ),
      )),
    );
  }
}
