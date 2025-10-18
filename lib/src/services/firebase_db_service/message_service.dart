import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;


class ChatService {
  final _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // only firebase
  Future<void> sendTextMessage(String receiverId, String messageText) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();

    // Save the message
    final message = MessageModel(
      text: messageText,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: now.toDate(),
      isMe: true,
    );

    await chatDocRef.collection('messages').add(message.toJson());

    // Get existing unreadCount
    final chatSnapshot = await chatDocRef.get();
    Map<String, dynamic> unreadCountMap = {};

    if (chatSnapshot.exists && chatSnapshot.data() != null) {
      unreadCountMap = Map<String, dynamic>.from(chatSnapshot.data()!['unreadCount'] ?? {});
    }

    // Increment unread count for receiver
    unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

    // Update last message, time, unread count
    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': messageText,
      'lastMessageTime': now,
      'unreadCount': unreadCountMap,
    }, SetOptions(merge: true));
  }

  Future<void> sendMediaMessage({
    required String receiverId,
    required File file,
    required String mediaType, // 'image', 'audio', or 'video'
  }) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);
    final now = Timestamp.now();
    final messageRef = chatDocRef.collection('messages').doc();

    try {
      print("Preparing file for upload...");

      // Normalize file extension
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

      print("Uploading to Supabase: $fileName");

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

      print("Upload successful. URL: $publicUrl");

      // Create message model
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
      print("Message saved to Firestore.");

      //  Handle unread counts
      final chatSnapshot = await chatDocRef.get();
      Map<String, dynamic> unreadCountMap = {};
      if (chatSnapshot.exists && chatSnapshot.data() != null) {
        unreadCountMap = Map<String, dynamic>.from(
          chatSnapshot.data()!['unreadCount'] ?? {},
        );
      }

      unreadCountMap[receiverId] = (unreadCountMap[receiverId] ?? 0) + 1;

      // Set last message preview
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
    } catch (e, stackTrace) {
      print("Error in sendMediaMessage: $e");
      print(stackTrace);
      rethrow;
    }
  }


  Future<void> markMessagesAsRead(String otherUserId) async {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(currentUserId, otherUserId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    final chatSnapshot = await chatDocRef.get();
    if (!chatSnapshot.exists) return;

    Map<String, dynamic> unreadCountMap = Map<String, dynamic>.from(
      chatSnapshot.data()?['unreadCount'] ?? {},
    );

    // Set unread count for current user to zero
    if ((unreadCountMap[currentUserId] ?? 0) > 0) {
      unreadCountMap[currentUserId] = 0;

      await chatDocRef.set({
        'unreadCount': unreadCountMap,
      }, SetOptions(merge: true));
    }
  }





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
