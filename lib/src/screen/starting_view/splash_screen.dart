/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loneliness/src/screen/starting_view/starting_controller.dart';


class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.sizeOf(context).width;
    Get.put(StartingController());

    return Scaffold(
      backgroundColor: Color(0xff4DB6AC),
      body: Center(child: SvgPicture.asset("assets/logo.svg",width: screenWidth*.6,)),
    );
  }
}
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
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
    checkUserStatus();
  }

  Future<void> checkUserStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    print('SplashScreen: UID from prefs = $uid');

    await Future.delayed(Duration(seconds: 1));

    if (uid != null) {
      print('Navigating to /bottomNav');
      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      print('Navigating to /onBoardingScreen');
      Get.offAllNamed(AppRoutes.onBoardingScreen);
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

