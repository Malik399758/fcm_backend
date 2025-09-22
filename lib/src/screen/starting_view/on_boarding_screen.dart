import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(

      
      floatingActionButton: Padding(
        padding:  EdgeInsets.symmetric(horizontal: screenWidth*.03,vertical: screenHeight*.08),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BlackText(
              onTap: (){},
              text: "skip",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.greenColor,
            ),
          ],
        ),
      ),
      
      body: SafeArea(child: Center(
        child: Padding(
          padding:  EdgeInsets.all(screenWidth*.05),
          child: Column(children: [
            SizedBox(height: screenHeight*.05),
           Container(
             width: screenWidth*.8,
             height: screenHeight*.32,
             child:  SvgPicture.asset(AppImages.onBoarding1,fit: BoxFit.cover,),
           ),
            SizedBox(height: screenHeight*.1),
           BlackText(
             text: "Memory Cycles",
             fontSize: 24,
             fontWeight: FontWeight.w600,
           ),
            SizedBox(height: screenHeight*.01),
           BlackText(
             text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ",
             fontSize: 14,
             fontWeight: FontWeight.w400,
             textColor: AppColors.greyColor,
           ),
            SizedBox(height: screenHeight*.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

              Container(
                height: screenHeight*.057,
                width: screenWidth*.12,
                decoration: BoxDecoration(
                  color: AppColors.transparentColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.greenColor)
                ),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: AppColors.greenColor)),
              ),

              
              Container(
                height: screenHeight*.057,
                width: screenWidth*.12,
                decoration: BoxDecoration(
                  color: AppColors.greenColor,
                  shape: BoxShape.circle,
                ),
                child: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward,color: AppColors.whiteColor)),
              ),


            ],)
          ],),
        ),
      ),),


    );
  }
}
