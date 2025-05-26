import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.replies,
  });

  factory Comment.fromFirestore(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      likes: List<String>.from(data['likes'] ?? []),
      replies: List<String>.from(data['replies'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'likes': likes,
      'replies': replies,
    };
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? createdAt,
    List<String>? likes,
    List<String>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }
}

class DiscussionModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String materialId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final List<String> likes;
  final List<Comment> comments;
  final bool isPinned;
  final bool isClosed;

  DiscussionModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.materialId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.isPinned,
    required this.isClosed,
  });

  factory DiscussionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> commentsData =
        List<Map<String, dynamic>>.from(data['comments'] ?? []);

    return DiscussionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      userAvatar: data['userAvatar'] ?? '',
      materialId: data['materialId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      tags: List<String>.from(data['tags'] ?? []),
      likes: List<String>.from(data['likes'] ?? []),
      comments: commentsData
          .asMap()
          .entries
          .map((entry) =>
              Comment.fromFirestore(entry.value, entry.key.toString()))
          .toList(),
      isPinned: data['isPinned'] ?? false,
      isClosed: data['isClosed'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'materialId': materialId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'tags': tags,
      'likes': likes,
      'comments': comments.map((c) => c.toFirestore()).toList(),
      'isPinned': isPinned,
      'isClosed': isClosed,
    };
  }

  DiscussionModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? materialId,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    List<String>? likes,
    List<Comment>? comments,
    bool? isPinned,
    bool? isClosed,
  }) {
    return DiscussionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      materialId: materialId ?? this.materialId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      isPinned: isPinned ?? this.isPinned,
      isClosed: isClosed ?? this.isClosed,
    );
  }
}
