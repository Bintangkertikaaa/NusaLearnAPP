import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String name;
  final String icon;
  final String description;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
  });
}

class LearningMaterial {
  final String id;
  final String categoryId;
  final String title;
  final String description;
  final String content;
  final String category;
  bool isCompleted;
  bool hasQuizCompleted;

  LearningMaterial({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    this.isCompleted = false,
    this.hasQuizCompleted = false,
  });
}

class MaterialModel {
  final String id;
  final String title;
  final String description;
  final String content;
  final String category;
  final String difficulty;
  final int xpPoints;
  final List<String> tags;
  final String mediaUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  MaterialModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.category,
    required this.difficulty,
    required this.xpPoints,
    required this.tags,
    required this.mediaUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaterialModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return MaterialModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      content: data['content'] ?? '',
      category: data['category'] ?? '',
      difficulty: data['difficulty'] ?? 'Pemula',
      xpPoints: data['xpPoints']?.toInt() ?? 0,
      tags: List<String>.from(data['tags'] ?? []),
      mediaUrl: data['mediaUrl'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'content': content,
      'category': category,
      'difficulty': difficulty,
      'xpPoints': xpPoints,
      'tags': tags,
      'mediaUrl': mediaUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MaterialModel copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? category,
    String? difficulty,
    int? xpPoints,
    List<String>? tags,
    String? mediaUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MaterialModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      xpPoints: xpPoints ?? this.xpPoints,
      tags: tags ?? this.tags,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
