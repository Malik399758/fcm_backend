import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/profile_model.dart';
import 'package:loneliness/src/services/firebase_db_service/supabase_storage_service.dart';

class ProfileService {
  final _db = FirebaseFirestore.instance;
 /* Future<String?> saveProfile(
      String name,
      String phone,
      String email,
      String dob,
      String gender, [
        File? avatarFile,
      ]) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return 'User not logged in';

      final profileRef = _db.collection('profile').doc(uid);
      final docSnapshot = await profileRef.get();

      String? imageUrl;
      if (avatarFile != null) {
        imageUrl = await SupabaseStorageService().uploadAvatar(uid, avatarFile);
      } else if (docSnapshot.exists) {

        final existingData = docSnapshot.data();
        imageUrl = existingData?['photoUrl'] as String?;
      }

      final profile = ProfileModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        dob: dob,
        relation: gender,
        photoUrl: imageUrl,
      );

      final data = {
        ...profile.toMap(),
        if (docSnapshot.exists)
          'updatedAt': FieldValue.serverTimestamp()
        else
          'createdAt': FieldValue.serverTimestamp(),
      };

      await profileRef.set(data, SetOptions(merge: true));

      return 'success';
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      print('Error saving profile: $e');
      return 'Profile saving issue';
    }
  }
*/

  Future<String?> saveProfile(
      String name,
      String phone,
      String email,
      String dob,
      String gender, [
        File? avatarFile,
        String? fcmToken, // 👈 new optional parameter
      ]) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return 'User not logged in';

      final profileRef = _db.collection('profile').doc(uid);
      final docSnapshot = await profileRef.get();

      String? imageUrl;
      if (avatarFile != null) {
        imageUrl = await SupabaseStorageService().uploadAvatar(uid, avatarFile);
      } else if (docSnapshot.exists) {
        final existingData = docSnapshot.data();
        imageUrl = existingData?['photoUrl'] as String?;
      }

      final profile = ProfileModel(
        uid: uid,
        name: name,
        phone: phone,
        email: email,
        dob: dob,
        relation: gender,
        photoUrl: imageUrl,
      );

      final data = {
        ...profile.toMap(),
        if (fcmToken != null) 'fcmToken': fcmToken, // 👈 store token here
        if (docSnapshot.exists)
          'updatedAt': FieldValue.serverTimestamp()
        else
          'createdAt': FieldValue.serverTimestamp(),
      };

      await profileRef.set(data, SetOptions(merge: true));

      return 'success';
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      print('Error saving profile: $e');
      return 'Profile saving issue';
    }
  }

  /// Fetch the current user's profile
  Future<ProfileModel?> getProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;

      final snap = await _db.collection('profile').doc(uid).get();

      if (snap.exists) {
        final data = snap.data();
        return ProfileModel.fromMap(data!);
      } else {
        print('Profile data not found');
        return null;
      }
    } catch (e) {
      print('Profile get error: $e');
      return null;
    }
  }

  /// Stream of other users' profiles (excluding current user)
  Stream<List<ProfileModel?>> getUsers() {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('User not logged in');
        return const Stream.empty();
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
      return const Stream.empty();
    }
  }
}
