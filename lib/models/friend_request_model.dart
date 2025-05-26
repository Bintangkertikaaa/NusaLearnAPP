import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String id;
  final String senderId;
  final String receiverId;
  final String status; // 'pending', 'accepted', 'rejected'
  final DateTime createdAt;

  FriendRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory FriendRequest.fromFirestore(Map<String, dynamic> data, String id) {
    return FriendRequest(
      id: id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
