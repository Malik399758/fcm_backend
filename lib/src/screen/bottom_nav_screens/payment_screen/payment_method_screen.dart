import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/payment_screen/payment_controller.dart';

import '../../../components/app_colors_images/app_images.dart' show AppImages;

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController controller = Get.put(PaymentController());
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlackText(
                  text: "Credit & Debit Card",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: screenHeight * .02),
                PaymentCardWidget(
                  onTap: () {
                    //Get.toNamed(AppRoutes.addCardScreen);
                  },
                  image: AppImages.newCard,
                  text: "Add New Card",
                  color: Color(0xffE9E9E9),
                ),
                SizedBox(height: screenHeight * .02),
                BlackText(
                  text: "More Payment Options",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                SizedBox(height: screenHeight * .02),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Color(0xffE9E9E9)),
                    borderRadius: BorderRadius.circular(15),
                  ),

                  child: Column(
                    children: [
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(top: screenHeight * .01),
                          child: PaymentCardWidget(
                            image: AppImages.paypal,
                            text: "PayPal",
                            isSelected: controller.isSelected("PayPal"),
                            onTap:
                                () => controller.selectPaymentMethod("PayPal"),
                          ),
                        ),
                      ),
                      Divider(color: Color(0xffE9E9E9), height: 0),
                      Obx(
                        () => Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * .01),
                          child: PaymentCardWidget(
                            image: AppImages.apple,
                            text: "Apple Pay",
                            isSelected: controller.isSelected("Apple Pay"),
                            onTap:
                                () =>
                                    controller.selectPaymentMethod("Apple Pay"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCardWidget extends StatelessWidget {
  final String image;
  final String text;
  final Color? color;
  final VoidCallback? onTap;
  final bool isSelected;

  const PaymentCardWidget({
    super.key,
    required this.image,
    required this.text,
    this.color,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.03),
          border: Border.all(color: color ?? Colors.transparent, width: 1),
        ),
        child: Row(
          children: [
            Center(
              child: SvgPicture.asset(
                image, // Uses image from list
                width: screenWidth * 0.08,
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Expanded(
              child: BlackText(
                text: text,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textColor: Colors.black,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: screenWidth * 0.015),
            Container(
              width: screenWidth * 0.06,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(
                  color:
                      isSelected ? AppColors.greenColor : AppColors.greyColor,
                ),
              ),
              child: Center(
                child: Container(
                  width: screenWidth * 0.025,
                  height: screenWidth * 0.025,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        isSelected ? AppColors.orangeColor : Colors.transparent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
