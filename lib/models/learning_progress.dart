import 'package:cloud_firestore/cloud_firestore.dart';

class LearningProgress {
  final String userId;
  final int totalPoints;
  final int readingCompleted;
  final int quizCompleted;
  final int gamesCompleted;
  final List<String> achievements;

  LearningProgress({
    required this.userId,
    this.totalPoints = 0,
    this.readingCompleted = 0,
    this.quizCompleted = 0,
    this.gamesCompleted = 0,
    List<String>? achievements,
  }) : achievements = achievements ?? [];

  // Get current level based on total points
  String get currentLevel {
    if (totalPoints >= 1000) {
      return 'Master';
    } else if (totalPoints >= 500) {
      return 'Ahli';
    } else if (totalPoints >= 200) {
      return 'Menengah';
    } else {
      return 'Pemula';
    }
  }

  // Create a copy of the current progress with updated values
  LearningProgress copyWith({
    int? totalPoints,
    int? readingCompleted,
    int? quizCompleted,
    int? gamesCompleted,
    List<String>? achievements,
  }) {
    return LearningProgress(
      userId: userId,
      totalPoints: totalPoints ?? this.totalPoints,
      readingCompleted: readingCompleted ?? this.readingCompleted,
      quizCompleted: quizCompleted ?? this.quizCompleted,
      gamesCompleted: gamesCompleted ?? this.gamesCompleted,
      achievements: achievements ?? this.achievements,
    );
  }

  // Add points and return new instance
  LearningProgress addPoints(int points) {
    return copyWith(totalPoints: totalPoints + points);
  }

  // Add achievement and return new instance
  LearningProgress addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      return copyWith(
        achievements: [...achievements, achievement],
      );
    }
    return this;
  }

  // Convert to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'totalPoints': totalPoints,
      'readingCompleted': readingCompleted,
      'quizCompleted': quizCompleted,
      'gamesCompleted': gamesCompleted,
      'achievements': achievements,
    };
  }

  // Create from Firestore data
  factory LearningProgress.fromFirestore(
      Map<String, dynamic> data, String userId) {
    return LearningProgress(
      userId: userId,
      totalPoints: data['totalPoints'] ?? 0,
      readingCompleted: data['readingCompleted'] ?? 0,
      quizCompleted: data['quizCompleted'] ?? 0,
      gamesCompleted: data['gamesCompleted'] ?? 0,
      achievements: List<String>.from(data['achievements'] ?? []),
    );
  }
}
