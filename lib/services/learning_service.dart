import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/learning_progress.dart';

class LearningService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Mendapatkan progress pembelajaran user
  Future<LearningProgress> getLearningProgress(String userId) async {
    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();
    if (doc.exists) {
      return LearningProgress.fromFirestore(doc.data()!);
    }
    // Jika dokumen belum ada, buat baru
    final newProgress = LearningProgress(userId: userId);
    await _firestore
        .collection('learning_progress')
        .doc(userId)
        .set(newProgress.toFirestore());
    return newProgress;
  }

  // Update progress setelah membaca materi
  Future<void> completeReading(String userId, int pointsEarned) async {
    final progress = await getLearningProgress(userId);
    final updatedProgress = progress.addPoints(pointsEarned);

    await _firestore.collection('learning_progress').doc(userId).set({
      'userId': userId,
      'readingCompleted': FieldValue.increment(1),
      'totalPoints': updatedProgress.totalPoints,
      'currentLevel': updatedProgress.currentLevel,
      'quizCompleted': progress.quizCompleted,
      'gamesCompleted': progress.gamesCompleted,
      'achievements': progress.achievements,
    }, SetOptions(merge: true));

    // Update user level di collection users
    await _firestore.collection('users').doc(userId).update({
      'level': updatedProgress.currentLevel,
      'points': updatedProgress.totalPoints,
    });
  }

  // Update progress setelah menyelesaikan kuis
  Future<void> completeQuiz(String userId, int score, int maxScore) async {
    final pointsEarned =
        (score / maxScore * 100).round(); // Konversi skor ke poin
    final progress = await getLearningProgress(userId);
    final updatedProgress = progress.addPoints(pointsEarned);

    await _firestore.collection('learning_progress').doc(userId).set({
      'userId': userId,
      'quizCompleted': FieldValue.increment(1),
      'totalPoints': updatedProgress.totalPoints,
      'currentLevel': updatedProgress.currentLevel,
      'readingCompleted': progress.readingCompleted,
      'gamesCompleted': progress.gamesCompleted,
      'achievements': progress.achievements,
    }, SetOptions(merge: true));

    // Update user level di collection users
    await _firestore.collection('users').doc(userId).update({
      'level': updatedProgress.currentLevel,
      'points': updatedProgress.totalPoints,
    });
  }

  // Update progress setelah menyelesaikan game
  Future<void> completeGame(String userId, int score) async {
    final progress = await getLearningProgress(userId);
    final updatedProgress = progress.addPoints(score);

    await _firestore.collection('learning_progress').doc(userId).set({
      'userId': userId,
      'gamesCompleted': FieldValue.increment(1),
      'totalPoints': updatedProgress.totalPoints,
      'currentLevel': updatedProgress.currentLevel,
      'readingCompleted': progress.readingCompleted,
      'quizCompleted': progress.quizCompleted,
      'achievements': progress.achievements,
    }, SetOptions(merge: true));

    // Update user level di collection users
    await _firestore.collection('users').doc(userId).update({
      'level': updatedProgress.currentLevel,
      'points': updatedProgress.totalPoints,
    });
  }

  // Menambah pencapaian baru
  Future<void> addAchievement(String userId, String achievement) async {
    final progress = await getLearningProgress(userId);
    final updatedProgress = progress.addAchievement(achievement);

    await _firestore.collection('learning_progress').doc(userId).set({
      'userId': userId,
      'achievements': updatedProgress.achievements,
      'readingCompleted': progress.readingCompleted,
      'quizCompleted': progress.quizCompleted,
      'gamesCompleted': progress.gamesCompleted,
      'totalPoints': progress.totalPoints,
      'currentLevel': progress.currentLevel,
    }, SetOptions(merge: true));

    // Update awards count di collection users
    await _firestore.collection('users').doc(userId).update({
      'awards': updatedProgress.achievements.length,
    });
  }
}
