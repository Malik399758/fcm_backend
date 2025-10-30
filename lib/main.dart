import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:loneliness/src/routes/app_routes.dart';
import 'package:loneliness/src/screen/auth_view/auth_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/bottom_nav/bottom_nav.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/record_nav_screens/record_nav_controller.dart';
import 'package:provider/provider.dart';
import 'package:loneliness/src/controllers/backend_controller/name_controller.dart';
import 'package:loneliness/src/screen/bottom_nav_screens/settings_nav_screens/settings_nav_controller.dart';
import 'package:loneliness/src/services/firebase_db_service/message_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 🔹 Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('🔔 Background Message: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Initialize Firebase
  await Firebase.initializeApp();

  // 🔹 Initialize Supabase
  await Supabase.initialize(
    url: 'https://cgbzkqjsohdkuxpombvb.supabase.co',
    anonKey:
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNnYnprcWpzb2hka3V4cG9tYnZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA2NDYxNTIsImV4cCI6MjA3NjIyMjE1Mn0.UwNEJSj2rvBwCYvPAN2p-gQ1y5GsKwUwqL-YyIB4QXk',
  );

  // 🔹 Setup Firebase Messaging
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Request notification permissions
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('🔔 Notification permission: ${settings.authorizationStatus}');

  // 🔹 Local notifications setup
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 🔹 Listen for foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('📩 Foreground message received: ${message.notification?.title}');
    final notification = message.notification;
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  // 🔹 Save FCM token & listen for token refresh
  await _saveFcmToken();
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    print('🔄 FCM Token refreshed: $newToken');
    await _saveFcmToken(newToken: newToken);
  });

  // Keep your existing GetX & Provider setup
  Get.put(SettingsNavController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NameProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// 🔹 Helper function to save/update FCM token
Future<void> _saveFcmToken({String? newToken}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final token = newToken ?? await FirebaseMessaging.instance.getToken();
  if (token == null) return;

  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
    'fcmToken': token, // Make sure field name matches notification sending
  }, SetOptions(merge: true));

  print('✅ FCM Token saved/updated: $token');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Loneliness',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splashScreen,
      getPages: AppRoutes.routes,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.put(BottomNavController());
        Get.lazyPut(() => RecordNavController(), fenix: true);
        Get.lazyPut(() => SettingsNavController(), fenix: true);
      }),
    );
  }
}
