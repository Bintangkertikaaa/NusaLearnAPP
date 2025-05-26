import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Menambah user baru
  Future<void> addUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toFirestore());
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
      await _firestore.collection('users').doc(userId).delete();
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
