import 'package:cloud_firestore/cloud_firestore.dart';

class LearningProgress {
  final String userId;
  final int readingCompleted; // Jumlah materi yang sudah dibaca
  final int quizCompleted; // Jumlah kuis yang sudah diselesaikan
  final int gamesCompleted; // Jumlah game yang sudah dimainkan
  final int totalPoints; // Total poin yang didapat
  final String currentLevel; // Level saat ini (Pemula, Menengah, Mahir)
  final List<String> achievements; // Daftar pencapaian yang sudah didapat

  LearningProgress({
    required this.userId,
    this.readingCompleted = 0,
    this.quizCompleted = 0,
    this.gamesCompleted = 0,
    this.totalPoints = 0,
    this.currentLevel = 'Pemula',
    this.achievements = const [],
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'readingCompleted': readingCompleted,
      'quizCompleted': quizCompleted,
      'gamesCompleted': gamesCompleted,
      'totalPoints': totalPoints,
      'currentLevel': currentLevel,
      'achievements': achievements,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  factory LearningProgress.fromFirestore(Map<String, dynamic> data) {
    return LearningProgress(
      userId: data['userId'] ?? '',
      readingCompleted: data['readingCompleted'] ?? 0,
      quizCompleted: data['quizCompleted'] ?? 0,
      gamesCompleted: data['gamesCompleted'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      currentLevel: data['currentLevel'] ?? 'Pemula',
      achievements: List<String>.from(data['achievements'] ?? []),
    );
  }

  // Method untuk menghitung level berdasarkan poin
  static String calculateLevel(int points) {
    if (points >= 1000) return 'Mahir';
    if (points >= 500) return 'Menengah';
    return 'Pemula';
  }

  // Method untuk menambah poin dan update level
  LearningProgress addPoints(int points) {
    final newTotalPoints = totalPoints + points;
    final newLevel = calculateLevel(newTotalPoints);

    return LearningProgress(
      userId: userId,
      readingCompleted: readingCompleted,
      quizCompleted: quizCompleted,
      gamesCompleted: gamesCompleted,
      totalPoints: newTotalPoints,
      currentLevel: newLevel,
      achievements: achievements,
    );
  }

  // Method untuk menambah pencapaian baru
  LearningProgress addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      final newAchievements = List<String>.from(achievements)..add(achievement);
      return LearningProgress(
        userId: userId,
        readingCompleted: readingCompleted,
        quizCompleted: quizCompleted,
        gamesCompleted: gamesCompleted,
        totalPoints: totalPoints,
        currentLevel: currentLevel,
        achievements: newAchievements,
      );
    }
    return this;
  }
}
