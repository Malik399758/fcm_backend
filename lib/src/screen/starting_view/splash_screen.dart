import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/screen/starting_view/starting_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkStatusAndNavigate();
  }

  Future<void> checkStatusAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboardingCompleted') ?? false;
    final uid = prefs.getString('uid');

    await Future.delayed(Duration(seconds: 2));

    if (!onboardingCompleted) {
      Get.put(StartingController());
      Get.offAllNamed(AppRoutes.onBoardingScreen);
    } else if (uid != null) {
      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      Get.offAllNamed(AppRoutes.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff4DB6AC),
      body: Center(child: SvgPicture.asset("assets/logo.svg")),
    );
  }
}
