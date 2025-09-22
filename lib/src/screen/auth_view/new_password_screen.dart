import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight= MediaQuery.sizeOf(context).height;
    final screenWidth= MediaQuery.sizeOf(context).width;
    final AuthController auth = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: screenWidth*.05,right: screenWidth*.05,bottom: screenHeight*.04),
          child: SingleChildScrollView(
            child: Form(
              key: auth.signUpFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight*.03),
                  CustomBackButton(),
                  SizedBox(height: screenHeight*.05),
                  Center(child: BlackText(text: "New Password", fontSize: 24, fontWeight: FontWeight.w500,textAlign: TextAlign.start,)),
                  SizedBox(height: screenHeight*.01),
                  Center(child: BlackText(text: "Your new password must be different\nfrom previously used passwords.", fontSize: 12, fontWeight: FontWeight.w400,textColor: AppColors.greyColor,)),
                  SizedBox(height: screenHeight*.05),
                  BlackText(
                    text: "Password",
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  SizedBox(height: screenHeight*.01),
                  TextFieldWidget(
                    controller: auth.passwordController,
                    hintText: "New Password",
                    isPassword: true,
                    validator: auth.validatePassword,
                  ),
                  SizedBox(height: screenHeight*.02),
                  BlackText(
                    text: "Confirm Password",
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                  ),
                  SizedBox(height: screenHeight*.01),
                  TextFieldWidget(
                    controller: auth.passwordController,
                    hintText: "Confirm New Password",
                    isPassword: true,
                    // isConfirmPasswordField: true,
                  ),
                  SizedBox(height: screenHeight*.3),
                  GreenButton(onTap: (){}, text: "Create New Password"),
                  SizedBox(height: screenHeight*.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
