



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/screen/auth_view/sign_in_view.dart';

import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isChecked = false;
  bool isLoading = false;
 final authService = AuthService();

  void handleForgotPassword() async {
    String email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter your email")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      await authService.resetPassword(email);

      Get.snackbar(
        'Success',
        'Password reset link sent to $email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is invalid.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email.';
          break;
        default:
          errorMessage = 'Something went wrong: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(errorMessage),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'Sorry',
        'Something wrong please try again later',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Back button stays at top
                        SizedBox(height: 10),
                       /// _buildBackButton(context),
                        CustomBackButton(),

                        // Spacer to push rest of content to center
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildTitle(),
                              SizedBox(height: 8),
                             _buildForgotText(),
                              SizedBox(height: 30),
                              _buildLabel('E-mail address'),
                              SizedBox(height: 7),
                              TextFieldWidget(controller: emailController, hintText: 'Reset Password'),
                              SizedBox(height: 8),
                              _buildForgotTextFieldTxt(),
                              SizedBox(height: 25),
                              GreenButton(text: isLoading ? 'Loading...' :'Send Recovery Link', onTap: () {
                                handleForgotPassword();
                                Get.to(() => SignInView());
                                /*Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                OtpScreen()));*/
                              }),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        'Forgot Password?',
        style: GoogleFonts.poppins(
          // color: AppTheme.getBlackColor(context),
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildForgotText(){
    return Text('Forgot Your Password? Don’t Worry we have your back',
      style: GoogleFonts.poppins(
        fontSize: 12,color: Colors.grey.shade700
          // fontSize: 12.sp,color: AppTheme.getLightColor(context)
      ),textAlign: TextAlign.center,);
  }

  Widget _buildForgotTextFieldTxt(){
    return Text('A link will be sent to your email to reset your password',
        style: GoogleFonts.poppins(
          color: Colors.grey.shade700,fontSize: 12
            // fontSize: 12.sp,color: AppTheme.getLightColor(context)
        ));
  }

  Widget _buildLabel(String text) {
    return Align(
      alignment: Alignment.topLeft,
      child: Text(
        text,
        style: GoogleFonts.poppins(
          color: Colors.black,
          // fontSize: 14.sp,
        ),
      ),
    );
  }

}