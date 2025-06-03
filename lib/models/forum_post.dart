import 'package:cloud_firestore/cloud_firestore.dart';

class ForumPost {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;
  final List<ForumReply> replies;
  final int replyCount;

  ForumPost({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
    this.replies = const [],
    this.replyCount = 0,
  });

  factory ForumPost.fromJson(Map<String, dynamic> json) {
    return ForumPost(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      replyCount: json['replyCount'] ?? 0,
      replies: (json['replies'] as List<dynamic>?)
              ?.map((reply) => ForumReply.fromJson(reply))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'replyCount': replyCount,
      'replies': replies.map((reply) => reply.toJson()).toList(),
    };
  }
}

class ForumReply {
  final String id;
  final String userId;
  final String userName;
  final String content;
  final DateTime timestamp;

  ForumReply({
    required this.id,
    required this.userId,
    required this.userName,
    required this.content,
    required this.timestamp,
  });

  factory ForumReply.fromJson(Map<String, dynamic> json) {
    return ForumReply(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      content: json['content'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
