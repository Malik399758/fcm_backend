import 'package:get/get.dart';
import 'package:loneliness/src/screen/auth_view/forgot_password.dart';
import 'package:loneliness/src/screen/auth_view/new_password_screen.dart';
import 'package:loneliness/src/screen/auth_view/sign_in_view.dart';
import 'package:loneliness/src/screen/auth_view/sign_up_screen.dart';
import 'package:loneliness/src/screen/auth_view/verify_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/chat_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/home_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/home_nav_screens/notification_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/video_record.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/voice_record.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/profile_info_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/reminder_calendar_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/reminder_frequency_screen.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_screen.dart';
import 'package:loneliness/src/screen/starting_view/on_boarding_screen.dart';
import 'package:loneliness/src/screen/starting_view/splash_screen.dart';

class AppRoutes {
  static final String splashScreen = "/";
  static final String onBoardingScreen = "/onBoardingScreen";
  static final String signInScreen = "/signInScreen";
  static final String signUpScreen = "/signUpScreen";
  static final String forgotPasswordScreen = "/forgotPasswordScreen";
  static final String verifyScreen = "/verifyScreen";
  static final String newPasswordScreen = "/newPasswordScreen";
  static final String bottomNav = "/bottomNav";
  static final String homeScreen = "/homeScreen";
  static final String notificationScreen = "/notificationScreen";
  static final String chatScreen = "/chatScreen";
  static final String voiceRecordScreen = "/voiceRecordScreen";
  static final String videoRecordScreen = "/videoRecordScreen";
  static final String settingsScreen = "/settingsScreen";
  static final String profileInfoScreen = "/profileInfoScreen";
  static final String reminderFrequencyScreen = "/reminderFrequencyScreen";
  static final String reminderCalendarScreen = "/reminderCalendarScreen";

  static final routes = [
    GetPage(name: splashScreen, page: () => SplashScreen()),
    GetPage(name: onBoardingScreen, page: () => OnBoardingScreen()),
    GetPage(name: signInScreen, page: () => SignInView()),
    GetPage(name: signUpScreen, page: () => SignUpScreen()),
    GetPage(name: forgotPasswordScreen, page: () => ForgotPassword()),
    GetPage(name: verifyScreen, page: () => VerifyScreen()),
    GetPage(name: newPasswordScreen, page: () => NewPasswordScreen()),
    GetPage(name: bottomNav, page: () => BottomNaV()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: notificationScreen, page: () => NotificationScreen()),
    GetPage(name: chatScreen, page: () => ChatScreen()),
    GetPage(name: voiceRecordScreen, page: () => VoiceRecordScreen()),
    GetPage(name: videoRecordScreen, page: () => VideoRecordScreen()),
    GetPage(name: settingsScreen, page: () => SettingsScreen()),
    GetPage(name: profileInfoScreen, page: () => ProfileInfoScreen()),
    GetPage(
      name: reminderFrequencyScreen,
      page: () => ReminderFrequencyScreen(),
    ),
    GetPage(name: reminderCalendarScreen, page: () => ReminderCalendarScreen()),
  ];
}
