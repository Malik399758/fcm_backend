import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/message_model.dart';


class ChatService {
  final _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  // old
 /* Future<void> sendTextMessage(String receiverId, String messageText) async {
    final senderId = FirebaseAuth.instance.currentUser!.uid;
    final chatId = _getChatId(senderId, receiverId);
    final chatDocRef = _db.collection('chats').doc(chatId);

    await chatDocRef.set({
      'users': [senderId, receiverId],
      'lastMessage': messageText,
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));


    final message = MessageModel(
      text: messageText,
      senderId: senderId,
      receiverId: receiverId,
      timestamp: DateTime.now(),
      isMe: true,
    );

    await chatDocRef.collection('messages').add(message.toJson());

    await chatDocRef.set({
      'lastMessage': messageText,
      'lastMessageTime': Timestamp.now(),
    }, SetOptions(merge: true));
  }*/

  // new
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
