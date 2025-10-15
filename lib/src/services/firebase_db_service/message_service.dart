import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loneliness/src/models/message_model.dart';


class ChatService {
  final _db = FirebaseFirestore.instance;

  String _getChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> sendTextMessage(String receiverId, String messageText) async {
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
