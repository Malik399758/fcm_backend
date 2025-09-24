import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileInfoController extends GetxController {
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

  void submit() {
    Get.snackbar('Profile', 'Profile information submitted');
  }
}
