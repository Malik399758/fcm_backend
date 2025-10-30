/*
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loneliness/src/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;

class ChatService {
  final _db = FirebaseFirestore.instance;


  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // Save FCM token for current user
  Future<void> saveUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Get current FCM token
    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    // Save token in Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'fcmToken': token,  // ⚠ use fcmToken, not token or tokens
    }, SetOptions(merge: true));

    print('FCM Token saved: $token');

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'fcmToken': newToken,
      }, SetOptions(merge: true));
      print('FCM Token updated: $newToken');
    });
  }


  // Send text message + FCM notification
  Future<void> sendTextMessage(String receiverId, String messageText) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();

    final message = MessageModel(
      text: messageText,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: now.toDate(),
      isMe: true,
    );

    // Save message in Firestore
    await chatDocRef.collection('messages').add(message.toJson());

    // Update unread count
    final chatSnapshot = await chatDocRef.get();
    Map<String, dynamic> unreadCountMap = {};
    if (chatSnapshot.exists && chatSnapshot.data() != null) {
      unreadCountMap = Map<String, dynamic>.from(
        chatSnapshot.data()!['unreadCount'] ?? {},
      );
    }
    unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

    // Update chat metadata
    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': messageText,
      'lastMessageTime': now,
      'unreadCount': unreadCountMap,
    }, SetOptions(merge: true));

    // Send push notification
    await _sendPushNotification(
      receiverId: receiverId,
      title: 'New Message',
      body: messageText,
    );
  }

  Future<void> _sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('profile').doc(receiverId).get();
      if (!userDoc.exists) return;

      final token = userDoc.data()?['fcmToken'];
      if (token == null) return;

      const String serverUrl = "https://loneliness-notify.onrender.com/send";

      final payload = {
        "token": token,
        "title": title,
        "body": body,
      };

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully to token: $token");
      } else {
        print("❌ Failed to send notification: ${response.body}");
      }

      // ALSO save notification to Firestore
      await _saveNotificationToFirestore(
        receiverId: receiverId,
        title: title,
        body: body,
      );

    } catch (e) {
      print("Error sending push notification: $e");
    }
  }



  Future<void> _saveNotificationToFirestore({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    final senderId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    final now = Timestamp.now();

    final notificationData = {
      'receiverId': receiverId,
      'senderId': senderId,
      'title': title,
      'body': body,
      'timestamp': now,
      'isRead': false,
    };

    try {
      await _db.collection('notifications').add(notificationData);
      print('Notification saved to Firestore');
    } catch (e) {
      print('Error saving notification: $e');
    }
  }


  Future<void> sendMediaMessage({
    required String receiverId,
    required File file,
    required String mediaType,
  }) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();
    final messageRef = chatDocRef.collection('messages').doc();

    try {
      print("Preparing file for upload...");

      String fileExt;
      String contentType;
      switch (mediaType.toLowerCase()) {
        case 'image':
          fileExt = '.jpg';
          contentType = 'image/jpeg';
          break;
        case 'audio':
          fileExt = '.m4a';
          contentType = 'audio/m4a';
          break;
        case 'video':
          fileExt = '.mp4';
          contentType = 'video/mp4';
          break;
        default:
          throw Exception('Unsupported media type: $mediaType');
      }

      final fileBytes = await file.readAsBytes();
      final fileName = 'media/${messageRef.id}$fileExt';

      final storage = Supabase.instance.client.storage.from('chat_media');
      await storage.uploadBinary(
        fileName,
        fileBytes,
        fileOptions: FileOptions(contentType: contentType),
      );

      final publicUrl = storage.getPublicUrl(fileName);
      if (publicUrl.isEmpty) {
        throw Exception("Supabase public URL is empty!");
      }

      print("Upload successful: $publicUrl");

      // Save message
      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        timestamp: now.toDate(),
        isMe: true,
        mediaUrl: publicUrl,
        type: mediaType.toLowerCase(),
        text: '',
      );

      await messageRef.set(message.toJson());

      // Update unread count
      final chatSnapshot = await chatDocRef.get();
      Map<String, dynamic> unreadCountMap = {};
      if (chatSnapshot.exists && chatSnapshot.data() != null) {
        unreadCountMap = Map<String, dynamic>.from(
          chatSnapshot.data()!['unreadCount'] ?? {},
        );
      }
      unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

      // Last message preview
      String lastMessagePreview;
      switch (mediaType.toLowerCase()) {
        case 'image':
          lastMessagePreview = '[Image]';
          break;
        case 'audio':
          lastMessagePreview = '[Voice]';
          break;
        case 'video':
          lastMessagePreview = '[Video]';
          break;
        default:
          lastMessagePreview = '[Media]';
      }

      await chatDocRef.set({
        'users': [senderId, receiverId],
        'lastMessage': lastMessagePreview,
        'lastMessageTime': now,
        'unreadCount': unreadCountMap,
      }, SetOptions(merge: true));

      print("Chat metadata updated.");

      // Send push notification for media
      await _sendPushNotification(
        receiverId: receiverId,
        title: 'New $mediaType message',
        body: lastMessagePreview,
      );
    } catch (e, stackTrace) {
      print("Error in sendMediaMessage: $e");
      print(stackTrace);
      rethrow;
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(currentUserId, otherUserId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    final chatSnapshot = await chatDocRef.get();
    if (!chatSnapshot.exists) return;

    Map<String, dynamic> unreadCountMap = Map<String, dynamic>.from(
      chatSnapshot.data()?['unreadCount'] ?? {},
    );

    if ((unreadCountMap[currentUserId] ?? 0) > 0) {
      unreadCountMap[currentUserId] = 0;
      await chatDocRef.set({
        'unreadCount': unreadCountMap,
      }, SetOptions(merge: true));
    }
  }

  // Stream messages between users
  Stream<List<MessageModel>> getMessages(String receiverId) {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);

    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data(), senderId))
        .toList());
  }

  // Ensure chat document exists
  Future<void> ensureChatExists(String receiverId) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
*/


import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:loneliness/src/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // 🔹 Save FCM token in profile collection
  Future<void> saveUserToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;

    await FirebaseFirestore.instance.collection('profile').doc(user.uid).set({
      'fcmToken': token,
    }, SetOptions(merge: true));

    print('✅ FCM Token saved in profile: $token');

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await FirebaseFirestore.instance.collection('profile').doc(user.uid).set({
        'fcmToken': newToken,
      }, SetOptions(merge: true));
      print('🔁 FCM Token updated: $newToken');
    });
  }

  // 🔹 Send text message + FCM notification
  Future<void> sendTextMessage(String receiverId, String messageText) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();

    final message = MessageModel(
      text: messageText,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: now.toDate(),
      isMe: true,
    );

    await chatDocRef.collection('messages').add(message.toJson());

    // unread count logic
    final chatSnapshot = await chatDocRef.get();
    Map<String, dynamic> unreadCountMap = {};
    if (chatSnapshot.exists && chatSnapshot.data() != null) {
      unreadCountMap =
      Map<String, dynamic>.from(chatSnapshot.data()!['unreadCount'] ?? {});
    }
    unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': messageText,
      'lastMessageTime': now,
      'unreadCount': unreadCountMap,
    }, SetOptions(merge: true));

    await _sendPushNotification(
      receiverId: receiverId,
      title: 'New Message',
      body: messageText,
    );
  }

  // 🔹 Send Push Notification
  Future<void> _sendPushNotification({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    try {
      // Fetch FCM token from profile collection
      final userDoc = await FirebaseFirestore.instance
          .collection('profile')
          .doc(receiverId)
          .get();

      if (!userDoc.exists) return;
      final token = userDoc.data()?['fcmToken'];
      if (token == null) return;

      const String serverUrl = "https://loneliness-notify.onrender.com/send";

      final payload = {
        "token": token,
        "title": title,
        "body": body,
      };

      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("✅ Notification sent successfully to token: $token");
      } else {
        print("❌ Failed to send notification: ${response.body}");
      }

      // Save notification details to Firestore
      await _saveNotificationToFirestore(
        receiverId: receiverId,
        title: title,
        body: body,
      );
    } catch (e) {
      print("Error sending push notification: $e");
    }
  }

  // 🔹 Save notification in 'notification' collection
  Future<void> _saveNotificationToFirestore({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    final senderId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
    final now = Timestamp.now();

    final notificationData = {
      'receiverId': receiverId,
      'senderId': senderId,
      'title': title,
      'body': body,
      'timestamp': now,
      'isRead': false,
    };

    try {
      await _db.collection('notification').add(notificationData);
      print('✅ Notification saved to Firestore (notification collection)');
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  // 🔹 Send media message (image/audio/video)
  Future<void> sendMediaMessage({
    required String receiverId,
    required File file,
    required String mediaType,
  }) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();
    final messageRef = chatDocRef.collection('messages').doc();

    try {
      print("Preparing file for upload...");

      String fileExt;
      String contentType;
      switch (mediaType.toLowerCase()) {
        case 'image':
          fileExt = '.jpg';
          contentType = 'image/jpeg';
          break;
        case 'audio':
          fileExt = '.m4a';
          contentType = 'audio/m4a';
          break;
        case 'video':
          fileExt = '.mp4';
          contentType = 'video/mp4';
          break;
        default:
          throw Exception('Unsupported media type: $mediaType');
      }

      final fileBytes = await file.readAsBytes();
      final fileName = 'media/${messageRef.id}$fileExt';

      final storage = Supabase.instance.client.storage.from('chat_media');
      await storage.uploadBinary(
        fileName,
        fileBytes,
        fileOptions: FileOptions(contentType: contentType),
      );

      final publicUrl = storage.getPublicUrl(fileName);
      if (publicUrl.isEmpty) throw Exception("Supabase public URL is empty!");

      print("✅ Upload successful: $publicUrl");

      final message = MessageModel(
        senderId: senderId,
        receiverId: receiverId,
        timestamp: now.toDate(),
        isMe: true,
        mediaUrl: publicUrl,
        type: mediaType.toLowerCase(),
        text: '',
      );

      await messageRef.set(message.toJson());

      // Update unread count
      final chatSnapshot = await chatDocRef.get();
      Map<String, dynamic> unreadCountMap = {};
      if (chatSnapshot.exists && chatSnapshot.data() != null) {
        unreadCountMap =
        Map<String, dynamic>.from(chatSnapshot.data()!['unreadCount'] ?? {});
      }
      unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

      String lastMessagePreview;
      switch (mediaType.toLowerCase()) {
        case 'image':
          lastMessagePreview = '[Image]';
          break;
        case 'audio':
          lastMessagePreview = '[Voice]';
          break;
        case 'video':
          lastMessagePreview = '[Video]';
          break;
        default:
          lastMessagePreview = '[Media]';
      }

      await chatDocRef.set({
        'users': [senderId, receiverId],
        'lastMessage': lastMessagePreview,
        'lastMessageTime': now,
        'unreadCount': unreadCountMap,
      }, SetOptions(merge: true));

      print("✅ Chat metadata updated.");

      await _sendPushNotification(
        receiverId: receiverId,
        title: 'New $mediaType message',
        body: lastMessagePreview,
      );
    } catch (e, stackTrace) {
      print("Error in sendMediaMessage: $e");
      print(stackTrace);
      rethrow;
    }
  }

  // 🔹 Mark messages as read
  Future<void> markMessagesAsRead(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(currentUserId, otherUserId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    final chatSnapshot = await chatDocRef.get();
    if (!chatSnapshot.exists) return;

    Map<String, dynamic> unreadCountMap = Map<String, dynamic>.from(
      chatSnapshot.data()?['unreadCount'] ?? {},
    );

    if ((unreadCountMap[currentUserId] ?? 0) > 0) {
      unreadCountMap[currentUserId] = 0;
      await chatDocRef.set({
        'unreadCount': unreadCountMap,
      }, SetOptions(merge: true));
    }
  }

  // 🔹 Stream messages between users
  Stream<List<MessageModel>> getMessages(String receiverId) {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);

    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => MessageModel.fromJson(doc.data(), senderId))
        .toList());
  }

  // 🔹 Ensure chat document exists
  Future<void> ensureChatExists(String receiverId) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': '',
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
