import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/components/common_widget/green_button.dart';
import 'package:loneliness/src/components/common_widget/text_field_widget.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/payment_screen/payment_controller.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    final TextEditingController nameController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController expireController = TextEditingController();
    final TextEditingController cvvController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: screenHeight*.25,
                  decoration: BoxDecoration(
                    color: AppColors.greenColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Stack(children: [
                    Positioned(
                      right: -screenWidth*.15,top: -screenHeight*.035,
                      child: WhiteContainer(),
                    ),
                    Positioned(
                      right: screenWidth*.12,top: -screenHeight*.09,
                      child: WhiteContainer(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth*.06,vertical: screenHeight*.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        BlackText(
                          text: "xxxx xxxx xxxx xxxx",
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: screenHeight*.02),
                        Row(children: [

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            BlackText(
                              text: "Card holder name",
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              textColor: Colors.white,
                            ),
                            SizedBox(height: screenHeight*.005),
                            BlackText(
                              text: "Arslan Qazi",
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              textColor: Colors.white,
                            ),

                          ],),
                          SizedBox(width: screenWidth*.07),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BlackText(
                                text: "Expire Date",
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                textColor: Colors.white,
                              ),
                              SizedBox(height: screenHeight*.005),
                              BlackText(
                                text: "02/30",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                textColor: Colors.white,
                              ),

                            ],),



                        ],),
                        ],),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: screenHeight*.025,horizontal: screenWidth*.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                              child: SvgPicture.asset('assets/chip.svg')),
                        ],
                      ),
                    ),
                    Positioned(
                        right: screenWidth*.05,top: screenHeight*.03,
                        child: SvgPicture.asset('assets/visa.svg',width: screenWidth*.15))




                  ],),
                ),
                SizedBox(height: screenHeight*.05),
                BlackText(
                  text: "Card Holder Name",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: screenHeight*.01),
                TextFieldWidget(controller: nameController, hintText: "Arslan Qazi"),

                SizedBox(height: screenHeight*.03),
                BlackText(
                  text: "Card Number",
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
                SizedBox(height: screenHeight*.01),
                TextFieldWidget(controller: numberController, hintText: "2856284627572615",keyboardType: TextInputType.number),
                SizedBox(height: screenHeight*.03),
                Row(children: [
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlackText(
                        text: "Expiry Date",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: screenHeight*.01),
                      TextFieldWidget(controller: expireController, hintText: "02/30",keyboardType: TextInputType.number),
                    ],)),
                  SizedBox(width: screenWidth*.05),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlackText(
                        text: "CVV",
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                      SizedBox(height: screenHeight*.01),
                      TextFieldWidget(controller: cvvController, hintText: "000",keyboardType: TextInputType.number,maxLength: 3,),
                    ],)),
                ],),
                SizedBox(height: screenHeight*.05),
                GreenButton(
                    onTap: (){},
                    text: "Add to cart",
                    borderRadius: 30,
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenHeight*.2,
      width: screenWidth*.45,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(.3),
          shape: BoxShape.circle
      ),
    );
  }
}

