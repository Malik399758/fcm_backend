
import 'package:get/get.dart';
import 'package:loneliness/src/screen/auth_view/forgot_password.dart';
import 'package:loneliness/src/screen/auth_view/new_password_screen.dart';
import 'package:loneliness/src/screen/auth_view/sign_in_view.dart';
import 'package:loneliness/src/screen/auth_view/sign_up_screen.dart';
import 'package:loneliness/src/screen/auth_view/verify_screen.dart';
import 'package:loneliness/src/screen/starting_view/on_boarding_screen.dart';
import 'package:loneliness/src/screen/starting_view/splash_screen.dart';

class AppRoutes {

  static final String splashScreen = "/" ;
  static final String onBoardingScreen = "/onBoardingScreen" ;
  static final String signInScreen = "/signInScreen" ;
  static final String signUpScreen = "/signUpScreen" ;
  static final String forgotPasswordScreen = "/forgotPasswordScreen" ;
  static final String verifyScreen = "/verifyScreen" ;
  static final String newPasswordScreen = "/newPasswordScreen" ;

  static final routes = [

    GetPage(name: splashScreen, page: ()=>SplashScreen()),
    GetPage(name: onBoardingScreen, page: ()=>OnBoardingScreen()),
    GetPage(name: signInScreen, page: ()=>SignInView()),
    GetPage(name: signUpScreen, page: ()=>SignUpScreen()),
    GetPage(name: forgotPasswordScreen, page: ()=>ForgotPassword()),
    GetPage(name: verifyScreen, page: ()=>VerifyScreen()),
    GetPage(name: newPasswordScreen, page: ()=>NewPasswordScreen()),

  ];


}