
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/group_message.dart';
import '../../models/group_model.dart';

class GroupService {
  final CollectionReference groupsRef = FirebaseFirestore.instance.collection('groups');
  final SupabaseClient _supabase = Supabase.instance.client;

  // 1. Create a new group
  Future<void> createGroup(GroupModel group) async {
    final docRef = groupsRef.doc(); // auto-generate ID
    await docRef.set(group.toMap());
  }

  // 2. Get all groups where user is a member
  Stream<List<GroupModel>> getGroupsForUser(String uid) {
    return groupsRef
        .where('members', arrayContains: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => GroupModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }

  // 3. Get all messages for a specific group
  Stream<List<GroupMessage>> getGroupMessages(String groupId) {
    return groupsRef
        .doc(groupId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => GroupMessage.fromMap(doc.data(), doc.id)).toList());
  }

  // 4. Send a text/media message to group
  Future<void> sendGroupMessage(String groupId, GroupMessage message) async {
    final messagesRef = groupsRef.doc(groupId).collection('messages');
    await messagesRef.add(message.toMap());

    // Update last message & time in group doc
    await groupsRef.doc(groupId).update({
      'lastMessage': message.messageType == 'text'
          ? message.message
          : '${message.senderName} sent a ${message.messageType}',
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  // 5. Upload media to Supabase Storage and return public URL
  Future<String?> uploadMediaToSupabase(File file, String mediaType) async {
    try {
      final ext = file.path.split('.').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$timestamp.$ext';
      final filePath = 'media/$fileName';

      final response = await _supabase.storage
          .from('chat_media')
          .upload(filePath, file);

      if (response.isEmpty) {
        throw Exception('File upload failed');
      }

      final publicUrl = _supabase.storage
          .from('chat_media')
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print('Upload Error: $e');
      return null;
    }
  }

  // 6. Send media message (image, audio, video)
  Future<void> sendMediaMessage({
    required String groupId,
    required String senderId,
    required String senderName,
    required File file,
    required String mediaType, // 'image', 'audio', 'video'
  }) async {
    final url = await uploadMediaToSupabase(file, mediaType);
    if (url == null) return;

    final mediaMessage = GroupMessage(
      senderId: senderId,
      senderName: senderName,
      message: '',
      timestamp: DateTime.now(),
      messageType: mediaType,
      mediaUrl: url,
    );

    await sendGroupMessage(groupId, mediaMessage);
  }
}
