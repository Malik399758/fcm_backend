import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final signInFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  var selectMethod = ''.obs;
  var isChecked = false.obs;


  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }


  String ? validateName (String? value){

    if (value == null || value.isEmpty){
      return "Name cannot be empty";
    }
    return null;

  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void signIn() {
    if (signInFormKey.currentState!.validate()) {
      Get.snackbar('Success', 'Sign In successful!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
  }

  void signup() {
    if (signUpFormKey.currentState!.validate()) {
      Get.snackbar('Success', 'Account Created Successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}