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
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/services/auth_service.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final AuthController authController = Get.put(AuthController());
  final authService = AuthService();
  bool loading = false;
  static const success = 'success';

  // Sign Up logic
  Future<void> _signIn() async {
    setState(() {
      loading = true;
    });

    try {
      final result = await authService.signIn(
        authController.emailController.text.trim(),
        authController.passwordController.text.trim(),
      );

      if (result == success){
        Get.snackbar(
          'Success',
          'Signed in successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNaV()));
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
              key: authController.signInFormKey,
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
                      text: "Sign In",
                      fontWeight: FontWeight.w500,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: screenHeight * .02),
                  Center(
                    child: BlackText(
                      text: "Hi! Welcome back, you’ve been missed",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      textColor: AppColors.greyColor,
                    ),
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
                  SizedBox(height: screenHeight * .01),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: BlackText(
                      onTap: () {
                       Get.toNamed(AppRoutes.forgotPasswordScreen);
                      },
                      text: "Forgot Password?",
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.greenColor,
                    ),
                  ),
                  SizedBox(height: screenHeight * .03),
                  GreenButton(
                    onTap: () async {
                      // Validate form
                      final formValid = authController.signInFormKey.currentState?.validate() ?? false;

                      if (!formValid) return;

                      // All validations passed
                      await _signIn();
                      authController.emailController.clear();
                      authController.passwordController.clear();
                    },
                    text: loading ? "Loading..." : "Sign In",
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
                        text: "Don’t have an account?",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      BlackText(
                        onTap: (){
                          Get.toNamed(AppRoutes.signUpScreen);
                        },
                        text: " Sign Up",
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