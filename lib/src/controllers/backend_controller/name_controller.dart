
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NameProvider extends ChangeNotifier {
  String _name = '';
  final db = FirebaseFirestore.instance;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _subscription;

  String get name => _name;

  // Start listening for real-time updates
  void startListening() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('User not logged in');
      return;
    }

    // Cancel previous subscription if any
    _subscription?.cancel();

    _subscription = db
        .collection('profile')
        .doc(uid)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        if (data != null) {
          _name = data['name'] ?? 'No Name';
          notifyListeners();
        }
      } else {
        print('No profile document found for UID: $uid');
      }
    }, onError: (error) {
      print('Error listening to profile updates: $error');
    });
  }

  // Call this to stop listening when no longer needed
  void stopListening() {
    _subscription?.cancel();
  }

  @override
  void dispose() {
    stopListening();
    super.dispose();
  }
}
