import 'package:get/get.dart';
import 'package:loneliness/src/routes/app_routes.dart';

class SettingsNavController extends GetxController {
  // Notification settings
  final RxBool newMessagesEnabled = false.obs;
  final RxBool reminderNotificationsEnabled = false.obs;

  // Reminder frequency
  final RxString reminderFrequency = 'Every 30 days'.obs;

  // Profile information
  String userName = 'John Doe';
  String userEmail = 'john.doe@example.com';
  String userPhoto = 'assets/user1.png';

  @override
  void onInit() {
    super.onInit();
    // Initialize any default values here
  }

  // Navigate to profile information
  void navigateToProfile() {
    Get.toNamed(AppRoutes.profileInfoScreen);
  }

  // Toggle new messages notification
  void toggleNewMessages() {
    newMessagesEnabled.value = !newMessagesEnabled.value;
  }

  // Toggle reminder notifications
  void toggleReminderNotifications() {
    reminderNotificationsEnabled.value = !reminderNotificationsEnabled.value;
  }

  // Navigate to reminder frequency
  void navigateToReminderFrequency() {
    Get.toNamed(AppRoutes.reminderFrequencyScreen);
  }

  // Navigate to manage subscription
  void navigateToManageSubscription() {
    // TODO: Navigate to subscription management screen
    Get.snackbar('Subscription', 'Navigate to Manage Subscription');
  }

  // Navigate to help & support
  void navigateToHelpSupport() {
    // TODO: Navigate to help & support screen
    Get.snackbar('Support', 'Navigate to Help & Support');
  }

  // Navigate to privacy policy
  void navigateToPrivacyPolicy() {
    // TODO: Navigate to privacy policy screen
    Get.snackbar('Privacy', 'Navigate to Privacy Policy');
  }
}
