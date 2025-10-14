

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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



  // logout method that works for both simple and Google login
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Try to sign out from Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();

        // Optional: Disconnect only if needed, wrap in try-catch
        try {
          await _googleSignIn.disconnect();
        } catch (e) {
          print("⚠️ Google disconnect failed (but signOut succeeded): $e");
        }
      }

      // Remove UID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');

      // Navigate to onboarding
      Get.offAllNamed(AppRoutes.onBoardingScreen);
    } catch (e) {
      print("❌ Error during logout: $e");
    }
  }




}