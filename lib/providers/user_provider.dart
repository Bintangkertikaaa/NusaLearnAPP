import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? get user => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  // Update user points
  Future<void> updatePoints(int points) async {
    if (_user == null) return;

    try {
      // Validate points
      if (points < 0) throw Exception('Points cannot be negative');

      final updatedUser = _user!.copyWith(points: points);

      // Update Firestore first
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'points': points});

      // If Firestore update succeeds, update local state
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating points: $e');
      rethrow;
    }
  }

  // Add friend
  Future<void> addFriend(String friendId) async {
    if (_user == null) return;
    if (friendId.isEmpty) throw Exception('Friend ID cannot be empty');
    if (_user!.friends.contains(friendId)) return; // Already friends

    try {
      final List<String> updatedFriends = List.from(_user!.friends)
        ..add(friendId);
      final updatedUser = _user!.copyWith(friends: updatedFriends);

      // Update Firestore first
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'friends': updatedFriends});

      // If Firestore update succeeds, update local state
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error adding friend: $e');
      rethrow;
    }
  }

  // Remove friend
  Future<void> removeFriend(String friendId) async {
    if (_user == null) return;
    if (friendId.isEmpty) throw Exception('Friend ID cannot be empty');
    if (!_user!.friends.contains(friendId)) return; // Not friends

    try {
      final List<String> updatedFriends = List.from(_user!.friends)
        ..remove(friendId);
      final updatedUser = _user!.copyWith(friends: updatedFriends);

      // Update Firestore first
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'friends': updatedFriends});

      // If Firestore update succeeds, update local state
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error removing friend: $e');
      rethrow;
    }
  }

  // Add award
  Future<void> addAward() async {
    if (_user == null) return;

    try {
      final updatedAwards = _user!.awards + 1;
      final updatedUser = _user!.copyWith(awards: updatedAwards);

      // Update Firestore first
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'awards': updatedAwards});

      // If Firestore update succeeds, update local state
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error adding award: $e');
      rethrow;
    }
  }

  // Update level
  Future<void> updateLevel(String newLevel) async {
    if (_user == null) return;
    if (newLevel.isEmpty) throw Exception('Level cannot be empty');

    try {
      final updatedUser = _user!.copyWith(level: newLevel);

      // Update Firestore first
      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update({'level': newLevel});

      // If Firestore update succeeds, update local state
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      print('Error updating level: $e');
      rethrow;
    }
  }
}
