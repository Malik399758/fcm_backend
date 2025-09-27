import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/screen/starting_view/starting_controller.dart';

import 'src/screen/bottom_nav_screens/record_nav_screens/record_nav_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Loneliness',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(backgroundColor: Colors.white, elevation: 0),
      ),

      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(StartingController());
        Get.put(AuthController());
        Get.put(BottomNavController());
        Get.lazyPut(() => RecordNavController(), fenix: true);
      }),
    );
  }
}
