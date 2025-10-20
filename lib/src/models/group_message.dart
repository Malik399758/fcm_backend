import 'package:cloud_firestore/cloud_firestore.dart';

class GroupMessage {
  final String senderId;
  final String senderName;
  final String message;        // For text messages, or caption for media
  final DateTime timestamp;
  final String messageType;    // e.g. 'text', 'image', 'voice', 'video'
  final String? mediaUrl;      // URL for media (image/audio/video), null for text messages

  GroupMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    this.messageType = 'text',
    this.mediaUrl,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> map, String id) {
    return GroupMessage(
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      message: map['message'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      messageType: map['messageType'] ?? 'text',
      mediaUrl: map['mediaUrl'],   // may be null for text messages
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'messageType': messageType,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,  // only include if non-null
    };
  }
}
