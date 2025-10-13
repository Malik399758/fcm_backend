import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String _name = '';
  final db = FirebaseFirestore.instance;

  String get name => _name;

  Future<void> getUser() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        print('User not logged in');
        return;
      }

      final snapshot = await db
          .collection('profile')
          .where('uid', isEqualTo: uid)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();

        // ✅ Only getting the 'name' field
        _name = data['name'] ?? 'No Name';

        print('Fetched name: $_name');

        notifyListeners();
      } else {
        print('No document found for uid');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
