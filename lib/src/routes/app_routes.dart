
import 'package:get/get.dart';
import 'package:loneliness/src/screen/starting_view/splash_screen.dart';

class AppRoutes {

  static final String splashScreen = "/" ;

  static final routes = [

    GetPage(name: splashScreen, page: ()=>SplashScreen()),


  ];


}