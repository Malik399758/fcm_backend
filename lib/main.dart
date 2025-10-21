import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loneliness/src/controllers/backend_controller/name_controller.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';
import 'package:loneliness/src/screen/starting_view/starting_controller.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'src/screen/bottom_nav_screens/record_nav_screens/record_nav_controller.dart';

void main() async{
  Get.put(SettingsNavController());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: 'https://cgbzkqjsohdkuxpombvb.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnYnprcWpzb2hka3V4cG9tYnZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2NDYxNTIsImV4cCI6MjA3NjIyMjE1Mn0.UwNEJSj2rvBwCYvPAN2p-gQ1y5GsKwUwqL-YyIB4QXk',
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => NameProvider()),
    ],child: MyApp(),));
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
        // Get.put(StartingController());
        Get.put(AuthController());
        Get.put(BottomNavController());
        Get.lazyPut(() => RecordNavController(), fenix: true);
        Get.lazyPut(() => SettingsNavController(), fenix: true);
      }),
    );
  }
}
