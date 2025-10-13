

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;

  // sign up
  Future<String?> signUp(String email,String password)async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      saveUserId();
      return 'success';
    }on FirebaseException catch(e){
      return e.message;
    }
    catch(e){
      return 'Something went wrong';
    }
  }

  // sign in
  Future<String?> signIn(String email,String password)async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      saveUserId();
      return 'success';
    }on FirebaseException catch(e){
      return e.message;
    }
    catch(e){
      return 'Something went wrong';
    }
  }


  // shared preference save user email

  void saveUserId() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', user.uid);
      print("Saved UID: ${user.uid}");
    }
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');

    Get.offAllNamed(AppRoutes.onBoardingScreen);
  }



}