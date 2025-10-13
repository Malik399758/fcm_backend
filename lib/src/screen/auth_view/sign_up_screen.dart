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
import 'package:loneliness/src/screen/auth_view/profile_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/profile_info_screen.dart';
import 'package:loneliness/src/services/auth_service.dart';
import 'package:loneliness/src/services/firebase_db_service/profile_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final authService = AuthService();
  final AuthController authController = Get.put(AuthController());
  static const success = 'success';

  bool loading = false;

  // Sign Up logic
  Future<void> _signUp() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await authService.signUp(
        authController.emailController.text.trim(),
        authController.passwordController.text.trim(),
      );

      if (result == success){
        Get.snackbar(
          'Success',
          'Account Created',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
      }else {
        Get.snackbar(
          'Error',
          result ?? 'Sign up failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Signup error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An unexpected error occurred')),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  BlackText(text: "Name", fontSize: 12),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.nameController,
                    hintText: "Arslan Qazi",
                    keyboardType: TextInputType.name,
                    validator: authController.validateName,
                  ),
                  SizedBox(height: screenHeight * .03),
                  BlackText(text: "Email", fontSize: 12),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.emailController,
                    hintText: "your@gmail.com",
                    keyboardType: TextInputType.emailAddress,
                    validator: authController.validateEmail,
                  ),
                  SizedBox(height: screenHeight * .03),
                  BlackText(text: "Password", fontSize: 12),
                  SizedBox(height: screenHeight * .006),
                  TextFieldWidget(
                    controller: authController.passwordController,
                    hintText: "****************",
                    isPassword: true,
                    validator: authController.validatePassword,
                  ),
                  SizedBox(height: screenHeight * .01),
                  Row(
                    children: [
                      Obx(() {
                        return Checkbox(
                          value: authController.isChecked.value,
                          onChanged: (value) {
                            authController.isChecked.value = value ?? false;
                          },
                          activeColor: AppColors.greenColor,
                          side: BorderSide(width: 1, color: AppColors.greyColor),
                        );
                      }),
                      BlackText(text: "Agree with", fontSize: 12),
                      BlackText(
                        text: " Terms & Condition",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.greenColor,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * .03),
                  GreenButton(
                    onTap: () async {
                      // Validate form
                      final formValid = authController.signUpFormKey.currentState?.validate() ?? false;

                      if (!formValid) return;

                      // Check terms & conditions
                      if (!authController.isChecked.value) {
                        Get.snackbar(
                          'Terms Required',
                          'You must agree to the Terms & Conditions.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                        return;
                      }

                      // All validations passed
                      await _signUp();
                      authController.emailController.clear();
                      authController.passwordController.clear();
                      authController.nameController.clear();
                    },
                    text: loading ? "Loading..." : "Sign Up",
                  ),
                  SizedBox(height: screenHeight * .03),
                  Center(
                    child: BlackText(
                      text: "OR",
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      textColor: AppColors.greyColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  GreenButton(
                    onTap: () {},
                    text: "Sign With Google",
                    image: AppImages.google,
                    color: AppColors.transparentColor,
                    textColor: AppColors.blackColor,
                    borderColor: const Color(0XFFDADADA),
                  ),
                  SizedBox(height: screenHeight * .02),
                  GreenButton(
                    onTap: () {},
                    text: "Sign With Facebook",
                    image: AppImages.facebook,
                    color: AppColors.transparentColor,
                    textColor: AppColors.blackColor,
                    borderColor: const Color(0XFFDADADA),
                  ),
                  SizedBox(height: screenHeight * .03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlackText(
                        text: "Already have an account?",
                        fontSize: 12,
                      ),
                      BlackText(
                        onTap: () {
                          Get.toNamed(AppRoutes.signInScreen);
                        },
                        text: " Sign In",
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.greenColor,
                      ),
                    ],
                  ),
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
