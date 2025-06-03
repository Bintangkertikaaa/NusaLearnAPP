import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/friend.dart';

class FriendService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Initialize default friends for new user
  Future<void> initializeDefaultFriends(String userId, String userEmail) async {
    try {
      print('Initializing friends for user: $userEmail'); // Debug log

      // Check if user already has friends or requests
      final receivedSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('received_requests')
          .get();

      final sentSnapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('sent_requests')
          .get();

      if (receivedSnapshot.docs.isEmpty && sentSnapshot.docs.isEmpty) {
        print('No existing requests found, creating new ones'); // Debug log

        final batch = _firestore.batch();

        // Jika user adalah Macika, tambahkan friend request dari Victor saja
        if (userEmail == 'camaci@gmail.com') {
          print('Creating request from Victor for Macika'); // Debug log

          // Add Victor friend request
          final victorRequest = {
            'id': 'victor123',
            'name': 'Victor D',
            'school': 'SD 5 BANDUNG',
            'points': 150,
            'level': 'Pemula',
          };

          // Add to received requests collection (untuk tab Diterima)
          batch.set(
            _firestore
                .collection('users')
                .doc(userId)
                .collection('received_requests')
                .doc('victor123'),
            victorRequest,
          );

          print('Created Victor request for Macika'); // Debug log
        }

        await batch.commit();
        print('Batch commit successful'); // Debug log
      } else {
        print(
            'User already has requests, skipping initialization'); // Debug log
      }
    } catch (e) {
      print('Error initializing default friends: $e');
    }
  }

  // Initialize chat history
  Future<void> _initializeChatHistory(String userId, String friendId) async {
    try {
      final chatId = _getChatId(userId, friendId);
      await _firestore.collection('chats').doc(chatId).set({
        'participants': [userId, friendId],
        'lastMessage': 'Selamat datang di NusaLearn!',
        'lastMessageTime': FieldValue.serverTimestamp(),
      });

      // Add welcome message
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add({
        'senderId': friendId,
        'text': 'Selamat datang di NusaLearn!',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error initializing chat history: $e');
    }
  }

  // Helper to generate consistent chat ID
  String _getChatId(String userId1, String userId2) {
    // Create a consistent chat ID by sorting user IDs
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }

  // Get received friend requests (untuk tab Diterima)
  Stream<List<Friend>> getReceivedRequests(String userId) {
    print('Getting received requests for user: $userId'); // Debug log
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('received_requests')
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Friend.fromJson(data);
      }).toList();
      print('Received requests count: ${requests.length}'); // Debug log
      return requests;
    });
  }

  // Get sent friend requests (untuk tab Menunggu)
  Stream<List<Map<String, dynamic>>> getSentRequests(String userId) {
    print('Getting sent requests for user: $userId'); // Debug log
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('sent_requests')
        .snapshots()
        .map((snapshot) {
      final requests = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return {
          'friend': Friend.fromJson(data),
          'status': data['status'] ?? 'pending'
        };
      }).toList();
      print('Sent requests count: ${requests.length}'); // Debug log
      return requests;
    });
  }

  // Get user's friends (for profile)
  Stream<List<Friend>> getFriends(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .snapshots()
        .asyncMap((snapshot) async {
      final friends = <Friend>[];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        data['id'] = doc.id;

        // Get last message if exists
        final chatId = _getChatId(userId, doc.id);
        final lastMessage = await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessage.docs.isNotEmpty) {
          final messageData = lastMessage.docs.first.data();
          messageData['id'] = lastMessage.docs.first.id;
          messageData['isMe'] = messageData['senderId'] == userId;
          data['messages'] = [messageData];
        } else {
          data['messages'] = [];
        }

        friends.add(Friend.fromJson(data));
      }

      // Sort friends: chatted friends first, then by last message time
      friends.sort((a, b) {
        if (a.messages.isEmpty && b.messages.isEmpty) {
          return a.name.compareTo(b.name);
        }
        if (a.messages.isEmpty) return 1;
        if (b.messages.isEmpty) return -1;
        return b.lastMessageTime.compareTo(a.lastMessageTime);
      });

      return friends;
    });
  }

  // Accept friend request
  Future<void> acceptFriendRequest(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      // Get friend's data
      final friendDoc =
          await _firestore.collection('users').doc(friendId).get();
      final friendData = friendDoc.data()!;

      // Get user's data
      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data()!;

      // Create friend objects
      final friend = Friend(
        id: friendId,
        name: friendData['name'],
        school: friendData['school'],
        points: friendData['points'] ?? 0,
        level: friendData['level'] ?? 'Pemula',
      );

      final user = Friend(
        id: userId,
        name: userData['name'],
        school: userData['school'],
        points: userData['points'] ?? 0,
        level: userData['level'] ?? 'Pemula',
      );

      // Add to friends collection
      batch.set(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('friends')
            .doc(friendId),
        friend.toJson(),
      );

      batch.set(
        _firestore
            .collection('users')
            .doc(friendId)
            .collection('friends')
            .doc(userId),
        user.toJson(),
      );

      // Remove from received requests
      batch.delete(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('received_requests')
            .doc(friendId),
      );

      // Update sent request status
      batch.update(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('sent_requests')
            .doc(friendId),
        {'status': 'accepted'},
      );

      await batch.commit();
    } catch (e) {
      print('Error accepting friend request: $e');
      rethrow;
    }
  }

  // Reject friend request
  Future<void> rejectFriendRequest(String userId, String friendId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('received_requests')
          .doc(friendId)
          .delete();
    } catch (e) {
      print('Error rejecting friend request: $e');
      rethrow;
    }
  }

  // Remove friend
  Future<void> removeFriend(String userId, String friendId) async {
    try {
      final batch = _firestore.batch();

      batch.delete(
        _firestore
            .collection('users')
            .doc(userId)
            .collection('friends')
            .doc(friendId),
      );

      batch.delete(
        _firestore
            .collection('users')
            .doc(friendId)
            .collection('friends')
            .doc(userId),
      );

      await batch.commit();
    } catch (e) {
      print('Error removing friend: $e');
      rethrow;
    }
  }

  Future<void> addFriend(String userId, Friend friend) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friend.id)
        .set(friend.toJson());
  }
}
