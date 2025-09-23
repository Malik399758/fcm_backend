import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

            SizedBox(height: screenHeight*.03),
            Row(children: [
              CustomBackButton(),
              Spacer(),
              BlackText(
                text: "Notification",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              Spacer(),
            ],),
            SizedBox(height: screenHeight*.05),
            BlackText(
              text: "Today",
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
              SizedBox(height: screenHeight*.03),
              NotificationWidget(
                  title: "New Video from Your Family!",
                  time: "2 m ago",
                  description: "just shared a new video. Open the app to watch and stay connected!"
              ),
              NotificationWidget(
                  title: "Stay in Touch",
                  time: "2 m ago",
                  description: "Don’t miss out on your family’s updates. Check your messages today!"
              ),
              BlackText(
                text: "Yesterday",
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              SizedBox(height: screenHeight*.03),
              NotificationWidget(
                  title: "New Video from Your Family!",
                  time: "2 m ago",
                  description: "just shared a new video. Open the app to watch and stay connected!"
              ),
              NotificationWidget(
                  title: "Stay in Touch",
                  time: "2 m ago",
                  description: "Don’t miss out on your family’s updates. Check your messages today!"
              ),

          ],),
        ),
      )),
    );
  }
}

class NotificationWidget extends StatelessWidget {

  final String title;
  final String description;
  final String time;

  const NotificationWidget({super.key,
    required this.title,
    required this.time,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      child: Container(
        width: screenWidth,
        height: screenHeight*.17,
        padding: EdgeInsets.all(screenWidth*.04),
        margin: EdgeInsets.only(bottom: screenHeight*.03),
        decoration: BoxDecoration(
          color: AppColors.greenColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: AppColors.transparentColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            Container(
              height: screenHeight*.056,
              width: screenWidth*.13,
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.transparentColor),
              ),
              child: Center(child: SvgPicture.asset(AppImages.bell,color: AppColors.greenColor,width: screenWidth*.08,),),
            ),

            SizedBox(width: screenWidth*.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlackText(
                          text: title,
                          textColor: AppColors.whiteColor,
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: screenHeight*.01),
                        BlackText(
                          text: description,
                          textColor: AppColors.whiteColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(width: screenWidth*.01),
            BlackText(
              text: time,
              textColor: AppColors.whiteColor,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),

          ],),
      ),
    );
  }
}

