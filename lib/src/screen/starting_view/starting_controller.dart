
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/components/app_colors_images/app_images.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartingController extends GetxController {
  var currentPage = 0.obs;
  final PageController pageController = PageController();

  final List<Map<String, dynamic>> onboardingData = [
    {
      'image': AppImages.onBoarding1,
      'title': 'Memory Cycles',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ',
    },
    {
      'image': AppImages.onBoarding2,
      'title': 'Private Family Spaces',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ',
    },
    {
      'image': AppImages.onBoarding3,
      'title': 'Share Precious Moments',
      'description': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor ',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    // No need for navigation here, SplashScreen handles initial route
  }

  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingCompleted', true);
    Get.offAllNamed(AppRoutes.signInScreen);
  }

  void nextPage() {
    if (currentPage.value < onboardingData.length - 1) {
      currentPage.value++;
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      completeOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      pageController.animateToPage(
        currentPage.value,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipOnboarding() {
    completeOnboarding();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
