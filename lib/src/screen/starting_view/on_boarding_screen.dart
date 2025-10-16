import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_colors.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/components/common_widget/black_text.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/starting_view/starting_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final StartingController controller = Get.find<StartingController>();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * .03,
          vertical: screenHeight * .08,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BlackText(
              onTap: controller.skipOnboarding,
              text: "Skip",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.greenColor,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * .05),
            child: Column(
              children: [
                SizedBox(height: screenHeight * .08),
                Container(
                  width: screenWidth * .8,
                  height: screenHeight * .32,
                  child: PageView.builder(
                    controller: controller.pageController,
                    itemCount: controller.onboardingData.length,
                    onPageChanged: (index) {
                      controller.currentPage.value = index;
                    },
                    itemBuilder: (context, index) {
                      return SvgPicture.asset(
                        controller.onboardingData[index]['image'],
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
                Spacer(),
                Obx(
                      () => BlackText(
                    text: controller.onboardingData[controller.currentPage.value]['title'],
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: screenHeight * .01),
                Obx(
                      () => BlackText(
                    text: controller.onboardingData[controller.currentPage.value]['description'],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.greyColor,
                  ),
                ),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                          () => Visibility(
                        visible: controller.currentPage.value > 0,
                        child: Container(
                          height: screenHeight * .057,
                          width: screenWidth * .12,
                          decoration: BoxDecoration(
                            color: AppColors.transparentColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.greenColor),
                          ),
                          child: IconButton(
                            onPressed: controller.previousPage,
                            icon: Icon(Icons.arrow_back, color: AppColors.greenColor),
                          ),
                        ),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: controller.pageController,
                      count: controller.onboardingData.length,
                      effect: WormEffect(
                        dotWidth: screenWidth * .03,
                        dotHeight: screenHeight * .015,
                        activeDotColor: AppColors.orangeColor,
                        dotColor: AppColors.orangeColor.withOpacity(.2),
                      ),
                      onDotClicked: (index) {
                        controller.currentPage.value = index;
                        controller.pageController.animateToPage(
                          index,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    Container(
                      height: screenHeight * .057,
                      width: screenWidth * .12,
                      decoration: BoxDecoration(
                        color: AppColors.greenColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: controller.nextPage,
                        icon: Icon(Icons.arrow_forward, color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}