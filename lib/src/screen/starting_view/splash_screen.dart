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
