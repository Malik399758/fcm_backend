import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Form(
              key: authController.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * .02),
                  Center(
                    child: SvgPicture.asset(
                      AppImages.appIcon,
                      width: screenWidth * .2,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  Center(
                    child: BlackText(
                      text: "Create Account",
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: screenHeight * .02),
                  Center(
                    child: BlackText(
                      text: "Fill your information below or register\nwith your social account.",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      textColor: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  BlackText(
                    text: "Name",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.nameController,
                    hintText: "Arslan Qazi",
                    keyboardType: TextInputType.emailAddress,
                    validator: authController.validateName,
                  ),


                  SizedBox(height: screenHeight * .03),
                  BlackText(
                    text: "Email",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.emailController,
                    hintText: "your@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: authController.validateEmail,
                  ),
                  SizedBox(height: screenHeight * .03),
                  BlackText(
                    text: "Password",
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.passwordController,
                    hintText: "****************",
                    isPassword: true,
                    validator: authController.validatePassword,
                  ),
                  SizedBox(height: screenHeight * .03),
                  // Row(children: [
                  //   Checkbox(value: true, onChanged: (value){})
                  // ],),
                  SizedBox(height: screenHeight * .03),
                  GreenButton(
                    onTap: authController.signIn,
                    text: "Sign Up",
                  ),
                  SizedBox(height: screenHeight * .03),
                  Center(child: BlackText(text: "OR",fontWeight: FontWeight.w600,fontSize: 12,textColor: AppColors.greyColor,)),
                  SizedBox(height: screenHeight * .03),
                  GreenButton(
                    onTap: (){},
                    text: "Sign With Google",
                    image: AppImages.google,
                    color: AppColors.transparentColor,
                    textColor: AppColors.blackColor,
                    borderColor: Color(0XFFDADADA),
                  ),
                  SizedBox(height: screenHeight * .02),
                  GreenButton(
                    onTap: (){},
                    text: "Sign With Facebook",
                    image: AppImages.facebook,
                    color: AppColors.transparentColor,
                    textColor: AppColors.blackColor,
                    borderColor: Color(0XFFDADADA),
                  ),
                  SizedBox(height: screenHeight * .03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlackText(
                        text: "Already  have an account?",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      BlackText(
                        onTap: (){
                          Get.toNamed(AppRoutes.signInScreen);
                        },
                        text: " Sign In",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.greenColor,
                      ),
                    ],),
                  SizedBox(height: screenHeight * .05),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}