import 'package:flutter/material.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/custom_back_button.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: AppColors.greenColor,
      body: SafeArea(child: Column(children: [

        Padding(
          padding:  EdgeInsets.all(screenWidth*.06),
          child: Row(children: [

            CustomBackButton(color: AppColors.whiteColor,borderColor: AppColors.transparentColor),
            SizedBox(width: screenWidth*.03),
            

          ],),
        )


      ],),),
    );
  }
}
