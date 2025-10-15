
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loneliness/src/models/profile_model.dart';

class UserChatPreview {
  final ProfileModel user;
  final String lastMessage;
  final Timestamp lastMessageTime;

  UserChatPreview({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}
