

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final _auth = FirebaseAuth.instance;
  // sign up

  Future<String?> signUp(String email,String password)async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return 'success';
    }on FirebaseException catch(e){
      return e.message;
    }
    catch(e){
      return 'Something went wrong';
    }
  }
}