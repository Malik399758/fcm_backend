
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/profile_model.dart';

class ProfileService{

  final _db = FirebaseFirestore.instance;

  // store user name

  Future<String?> saveProfile(String name, String phone, String email, String dob, String gender) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        return 'User not logged in';
      }

      final profileRef = _db.collection('profile').doc(uid);
      final docSnapshot = await profileRef.get();

      final profile = ProfileModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        dob: dob,
        relation: gender,
      );

      if (docSnapshot.exists) {
        // Update existing profile, add updatedAt timestamp
        await profileRef.update({
          ...profile.toMap(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new profile, add createdAt timestamp
        await profileRef.set({
          ...profile.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return 'success';
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return 'Profile saving issue';
    }
  }


  Future<ProfileModel?> getProfile()async{
    try{
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if(uid == null) return null;
      final snap = await _db.collection('profile').doc(uid).get();

      if(snap.exists){
        final data = snap.data();
        return ProfileModel.fromMap(data!);
      }else{
        print('profile data not found');
        return null;
      }
    }catch(e){
      print('profile get error');
      return null;
    }
  }

  Stream<List<ProfileModel?>> getUsers() {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid == null) {
        print('User not logged in');
        return const Stream.empty(); // Return an empty stream
      }

      return _db
          .collection('profile')
          .where('uid', isNotEqualTo: uid)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ProfileModel.fromMap(doc.data());
        }).toList();
      });
    } catch (e) {
      print('Error in getUsers: $e');
      return const Stream.empty(); // Return empty stream on error
    }
  }





}