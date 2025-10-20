
// models/group_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  final String id;
  final String name;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data, String id) {
    return GroupModel(
      id: id,
      name: data['name'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdBy: data['createdBy'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt,
    };
  }
}
