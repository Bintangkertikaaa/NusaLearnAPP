import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/learning_progress.dart';

class LearningService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get user's learning progress
  Future<LearningProgress> getLearningProgress(String userId) async {
    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();

    if (doc.exists) {
      return LearningProgress.fromFirestore(doc.data()!, userId);
    }

    // If document doesn't exist, create new
    final newProgress = LearningProgress(userId: userId);
    await _firestore
        .collection('learning_progress')
        .doc(userId)
        .set(newProgress.toFirestore());
    return newProgress;
  }

  // Update progress after reading material
  Future<void> completeReading(String userId, int pointsEarned) async {
    // Base points for completing reading
    final basePoints = 5;
    // Bonus points for engagement (pointsEarned parameter) - max 5 points
    final bonusPoints = pointsEarned > 5 ? 5 : pointsEarned;
    final totalPoints = basePoints + bonusPoints;

    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();
    final progress = LearningProgress.fromFirestore(doc.data()!, userId);

    final updatedProgress = progress.addPoints(totalPoints).copyWith(
          readingCompleted: progress.readingCompleted + 1,
        );

    // Use batch write for consistency
    final batch = _firestore.batch();

    // Update learning progress
    final progressRef = _firestore.collection('learning_progress').doc(userId);
    batch.set(progressRef, updatedProgress.toFirestore());

    // Update user points and level
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'points': FieldValue.increment(totalPoints),
      'level': updatedProgress.currentLevel,
    });

    await batch.commit();
  }

  // Update progress after completing quiz
  Future<void> completeQuiz(String userId, int score, int maxScore) async {
    // Base points: 5 points per correct answer
    final pointsPerQuestion = 5;
    final basePoints =
        (score * pointsPerQuestion); // if score is number of correct answers

    // Bonus points for high performance
    int bonusPoints = 0;
    if (score == maxScore) {
      bonusPoints = 10; // Perfect score bonus
    } else if ((score / maxScore) >= 0.8) {
      bonusPoints = 5; // High score bonus (80% or better)
    }

    final totalPoints = basePoints + bonusPoints;

    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();
    final progress = LearningProgress.fromFirestore(doc.data()!, userId);

    final updatedProgress = progress.addPoints(totalPoints).copyWith(
          quizCompleted: progress.quizCompleted + 1,
        );

    // Use batch write for consistency
    final batch = _firestore.batch();

    // Update learning progress
    final progressRef = _firestore.collection('learning_progress').doc(userId);
    batch.set(progressRef, updatedProgress.toFirestore());

    // Update user points and level
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'points': FieldValue.increment(totalPoints),
      'level': updatedProgress.currentLevel,
    });

    await batch.commit();
  }

  // Update progress after completing game
  Future<void> completeGame(String userId, int score) async {
    // Points for completing a game level (50 points per level)
    final levelPoints = 50;

    // Bonus points for high score in the level (up to 10 additional points)
    final bonusPoints = (score >= 90)
        ? 10
        : (score >= 75)
            ? 5
            : (score >= 60)
                ? 3
                : 0;

    final totalPoints = levelPoints + bonusPoints;

    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();
    final progress = LearningProgress.fromFirestore(doc.data()!, userId);

    final updatedProgress = progress.addPoints(totalPoints).copyWith(
          gamesCompleted: progress.gamesCompleted + 1,
        );

    // Use batch write for consistency
    final batch = _firestore.batch();

    // Update learning progress
    final progressRef = _firestore.collection('learning_progress').doc(userId);
    batch.set(progressRef, updatedProgress.toFirestore());

    // Update user points and level
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'points': FieldValue.increment(totalPoints),
      'level': updatedProgress.currentLevel,
    });

    await batch.commit();
  }

  // Add new achievement
  Future<void> addAchievement(String userId, String achievement) async {
    // Points earned for getting a new achievement
    final achievementPoints = 25;

    final doc =
        await _firestore.collection('learning_progress').doc(userId).get();
    final progress = LearningProgress.fromFirestore(doc.data()!, userId);

    // Add achievement and points
    final updatedProgress =
        progress.addAchievement(achievement).addPoints(achievementPoints);

    // Use batch write for consistency
    final batch = _firestore.batch();

    // Update learning progress
    final progressRef = _firestore.collection('learning_progress').doc(userId);
    batch.set(progressRef, updatedProgress.toFirestore());

    // Update user points, level, and awards
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'points': FieldValue.increment(achievementPoints),
      'level': updatedProgress.currentLevel,
      'awards': updatedProgress.achievements.length,
    });

    await batch.commit();
  }
}
