
import 'package:get/get.dart';
import 'package:loneliness/src/screen/auth_view/sign_in_view.dart';
import 'package:loneliness/src/screen/starting_view/on_boarding_screen.dart';
import 'package:loneliness/src/screen/starting_view/splash_screen.dart';

class AppRoutes {

  static final String splashScreen = "/" ;
  static final String onBoardingScreen = "/onBoardingScreen" ;
  static final String signInScreen = "/signInScreen" ;

  static final routes = [

    GetPage(name: splashScreen, page: ()=>SplashScreen()),
    GetPage(name: onBoardingScreen, page: ()=>OnBoardingScreen()),
    GetPage(name: signInScreen, page: ()=>SignInView()),

  ];


}