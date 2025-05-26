import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatsModel {
  final String id;
  final String userId;
  final int totalStudyTime;
  final int materialsCompleted;
  final int quizzesTaken;
  final double averageScore;
  final Map<String, int> categoryProgress;
  final Map<String, int> weeklyActivity;
  final int streak;
  final DateTime lastActive;
  final DateTime updatedAt;

  UserStatsModel({
    required this.id,
    required this.userId,
    required this.totalStudyTime,
    required this.materialsCompleted,
    required this.quizzesTaken,
    required this.averageScore,
    required this.categoryProgress,
    required this.weeklyActivity,
    required this.streak,
    required this.lastActive,
    required this.updatedAt,
  });

  factory UserStatsModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserStatsModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      totalStudyTime: data['totalStudyTime']?.toInt() ?? 0,
      materialsCompleted: data['materialsCompleted']?.toInt() ?? 0,
      quizzesTaken: data['quizzesTaken']?.toInt() ?? 0,
      averageScore: (data['averageScore'] ?? 0.0).toDouble(),
      categoryProgress: Map<String, int>.from(data['categoryProgress'] ?? {}),
      weeklyActivity: Map<String, int>.from(data['weeklyActivity'] ?? {}),
      streak: data['streak']?.toInt() ?? 0,
      lastActive: (data['lastActive'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'totalStudyTime': totalStudyTime,
      'materialsCompleted': materialsCompleted,
      'quizzesTaken': quizzesTaken,
      'averageScore': averageScore,
      'categoryProgress': categoryProgress,
      'weeklyActivity': weeklyActivity,
      'streak': streak,
      'lastActive': Timestamp.fromDate(lastActive),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  UserStatsModel copyWith({
    String? id,
    String? userId,
    int? totalStudyTime,
    int? materialsCompleted,
    int? quizzesTaken,
    double? averageScore,
    Map<String, int>? categoryProgress,
    Map<String, int>? weeklyActivity,
    int? streak,
    DateTime? lastActive,
    DateTime? updatedAt,
  }) {
    return UserStatsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalStudyTime: totalStudyTime ?? this.totalStudyTime,
      materialsCompleted: materialsCompleted ?? this.materialsCompleted,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      averageScore: averageScore ?? this.averageScore,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      weeklyActivity: weeklyActivity ?? this.weeklyActivity,
      streak: streak ?? this.streak,
      lastActive: lastActive ?? this.lastActive,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
