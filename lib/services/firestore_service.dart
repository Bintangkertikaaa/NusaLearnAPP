import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/learning_progress.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menambah user baru
  Future<void> addUser(UserModel user) async {
    try {
      // Use batch write for consistency
      final batch = _firestore.batch();

      // Add user data
      final userRef = _firestore.collection('users').doc(user.id);
      batch.set(userRef, user.toFirestore());

      // Initialize learning progress
      final progressRef =
          _firestore.collection('learning_progress').doc(user.id);
      final newProgress = LearningProgress(userId: user.id);
      batch.set(progressRef, newProgress.toFirestore());

      await batch.commit();
    } catch (e) {
      print('Error adding user: $e');
      rethrow;
    }
  }

  // Mengambil data user berdasarkan ID
  Future<UserModel?> getUser(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromFirestore(
            doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting user: $e');
      rethrow;
    }
  }

  // Mengupdate data user
  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      print('Error updating user: $e');
      rethrow;
    }
  }

  // Menghapus user
  Future<void> deleteUser(String userId) async {
    try {
      final batch = _firestore.batch();

      // Delete user data
      batch.delete(_firestore.collection('users').doc(userId));

      // Delete learning progress
      batch.delete(_firestore.collection('learning_progress').doc(userId));

      await batch.commit();
    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }

  // Mengambil semua users
  Stream<List<UserModel>> getAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return UserModel.fromFirestore(doc.data(), doc.id);
      }).toList();
    });
  }
}
