
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/profile_model.dart';

class ProfileService{

  final _db = FirebaseFirestore.instance;

  // store user name

  Future<String?> saveProfile(String name,String phone,String email,String dob,String gender)async{
    try{
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if(uid == null){
        return 'user not logged in';
      }else{
        final profile = ProfileModel(uid: uid, name: name, phone: phone, email: email, dob: dob, relation: gender);
        await _db.collection('profile').doc(uid).set({
          ...profile.toMap(),
          'createdAt' : FieldValue.serverTimestamp()
        });
        return 'success';
      }
    } on FirebaseException catch(e){
      return e.message;
    }
    catch(e){
      return 'profile creating issue';
    }
  }



}