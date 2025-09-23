import 'package:flutter/material.dart';
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

          ],),
        ),
      )),
    );
  }
}
