
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final String? mediaUrl;
  final String? type;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.mediaUrl,
    this.type
  });

  // Convert Firestore document to MessageModel
  factory MessageModel.fromJson(Map<String, dynamic> json,String currentUserId) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      mediaUrl: json['mediaUrl'],
      type: json['type'],
      isMe: json['senderId'] == currentUserId,
    );
  }

  // Convert MessageModel to Firestore document format
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
      'mediaUrl': mediaUrl,
      'type': type ?? 'text',
    };
  }
}
