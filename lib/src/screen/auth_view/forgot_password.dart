import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';
class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final AuthController authController = Get.put(AuthController());
    return Scaffold(
      body: SafeArea(child: Padding(
        padding: EdgeInsets.all(screenWidth*.05),
        child: Obx((){

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*.03),
              CustomBackButton(),
              SizedBox(height: screenHeight*.03),
              Center(
                child: BlackText(
                  text: "Forget Password",
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: screenHeight*.02),
              Center(
                child: BlackText(
                  text: "Select which contact details should we use to\nreset your password",
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: screenHeight*.03),
              GestureDetector(
                onTap: (){
                  authController.selectMethod('sms');
                },
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(screenWidth*.04),
                  decoration: BoxDecoration(
                    border: Border.all(color: authController.selectMethod.value=='sms'?AppColors.greenColor : AppColors.transparentColor,width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Container(
                      height: screenHeight*.063,
                      width: screenWidth*.15,
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: SvgPicture.asset(AppImages.sms,width: screenWidth*.07,),),
                    ),
                    SizedBox(width: screenWidth*.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlackText(
                          text: "via sms",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.greenColor,
                        ),
                        SizedBox(height: screenHeight*.01),
                        BlackText(
                          text: "+88248****89",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],)


                  ],),
                ),
              ),
              SizedBox(height: screenHeight*.03),
              GestureDetector(
                onTap: (){
                  authController.selectMethod('msg');
                },
                child: Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(screenWidth*.04),
                  decoration: BoxDecoration(
                    border: Border.all(color: authController.selectMethod.value=='msg'?AppColors.greenColor : AppColors.transparentColor,width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(children: [
                    Container(
                      height: screenHeight*.063,
                      width: screenWidth*.15,
                      decoration: BoxDecoration(
                        color: AppColors.greenColor.withOpacity(.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: SvgPicture.asset(AppImages.email,width: screenWidth*.07,),),
                    ),
                    SizedBox(width: screenWidth*.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlackText(
                          text: "via email",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.greenColor,
                        ),
                        SizedBox(height: screenHeight*.01),
                        BlackText(
                          text: "your@gmail.com",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ],)


                  ],),
                ),
              ),
              SizedBox(height: screenHeight*.3),
              GreenButton(
                onTap: (){
                  Get.toNamed(AppRoutes.verifyScreen);
                },
                text: "Verify",
              )

            ],);

        })
      )),
    );
  }
}
