import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loneliness/src/routes/app_routes.dart';

class SettingsNavController extends GetxController {
  // Notification settings
  final RxBool newMessagesEnabled = false.obs;
  final RxBool reminderNotificationsEnabled = false.obs;

  // Reminder frequency
  final RxString reminderFrequency = 'Every 30 days'.obs;

  // Profile information
  final TextEditingController nameController = TextEditingController(
    text: 'Salman',
  );
  final TextEditingController phoneController = TextEditingController(
    text: '0000000',
  );
  final TextEditingController emailController = TextEditingController(
    text: 'example@gmail.com',
  );
  final TextEditingController dobController = TextEditingController();
  final RxString selectedGender = ''.obs; // '', 'Male', 'Female', 'Other'
  final Rx<File?> avatarFile = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

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


  //==================== Profile actions ====================
  Future<void> takePhoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (image != null) {
      avatarFile.value = File(image.path);
    }
  }

  Future<void> pickFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null) {
      avatarFile.value = File(image.path);
    }
  }

  void setGender(String value) {
    selectedGender.value = value;
  }

  void submitProfile() {
    Get.snackbar('Profile', 'Profile information submitted');
  }

  //==================== Reminder state/actions ====================
  final RxInt selectedPresetIndex = 0.obs; // 0:30d, 1:60d, 2:custom
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rxn<DateTime> selectedDay = Rxn<DateTime>();
  final RxList<DateTime> selectedDates = <DateTime>[].obs;

  void selectPreset(int index) {
    selectedPresetIndex.value = index;
  }

  void onDaySelected(DateTime day, DateTime focus) {
    selectedDay.value = day;
    focusedDay.value = focus;
    final bool exists = selectedDates.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
    if (exists) {
      selectedDates.removeWhere(
        (d) => d.year == day.year && d.month == day.month && d.day == day.day,
      );
    } else {
      selectedDates.add(day);
    }
  }

  void clearSelections() {
    selectedDay.value = null;
    selectedDates.clear();
  }

  void saveReminder() {
    Get.back();
    Get.snackbar('Reminder', 'Memory cycle saved');
  }
}
