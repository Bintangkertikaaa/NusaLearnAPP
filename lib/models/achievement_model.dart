import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconUrl;
  final int pointsRequired;
  final String type;
  final Map<String, dynamic> criteria;
  final DateTime createdAt;
  final DateTime updatedAt;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.pointsRequired,
    required this.type,
    required this.criteria,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AchievementModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return AchievementModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      iconUrl: data['iconUrl'] ?? '',
      pointsRequired: data['pointsRequired']?.toInt() ?? 0,
      type: data['type'] ?? '',
      criteria: Map<String, dynamic>.from(data['criteria'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'iconUrl': iconUrl,
      'pointsRequired': pointsRequired,
      'type': type,
      'criteria': criteria,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  AchievementModel copyWith({
    String? id,
    String? title,
    String? description,
    String? iconUrl,
    int? pointsRequired,
    String? type,
    Map<String, dynamic>? criteria,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AchievementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      pointsRequired: pointsRequired ?? this.pointsRequired,
      type: type ?? this.type,
      criteria: criteria ?? this.criteria,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

// Model untuk pencapaian user
class UserAchievementModel {
  final String id;
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;
  final bool isDisplayed;
  final Map<String, dynamic> progress;

  UserAchievementModel({
    required this.id,
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
    required this.isDisplayed,
    required this.progress,
  });

  factory UserAchievementModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserAchievementModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      achievementId: data['achievementId'] ?? '',
      unlockedAt: (data['unlockedAt'] as Timestamp).toDate(),
      isDisplayed: data['isDisplayed'] ?? false,
      progress: Map<String, dynamic>.from(data['progress'] ?? {}),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'achievementId': achievementId,
      'unlockedAt': Timestamp.fromDate(unlockedAt),
      'isDisplayed': isDisplayed,
      'progress': progress,
    };
  }

  UserAchievementModel copyWith({
    String? id,
    String? userId,
    String? achievementId,
    DateTime? unlockedAt,
    bool? isDisplayed,
    Map<String, dynamic>? progress,
  }) {
    return UserAchievementModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      achievementId: achievementId ?? this.achievementId,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      isDisplayed: isDisplayed ?? this.isDisplayed,
      progress: progress ?? this.progress,
    );
  }
}
