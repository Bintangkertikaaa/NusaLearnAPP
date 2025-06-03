import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ChatMessage>> getChatMessages(String userId, String friendId) {
    final chatId = _getChatId(userId, friendId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        data['isMe'] = data['senderId'] == userId;
        return ChatMessage.fromJson(data);
      }).toList();
    });
  }

  Future<void> sendMessage(String userId, String friendId, String text) async {
    final chatId = _getChatId(userId, friendId);
    final timestamp = DateTime.now();

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': text,
      'senderId': userId,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'isRead': false,
    });

    // Update last message in both users' friend lists
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendId)
        .update({
      'lastMessage': text,
      'lastMessageTime': timestamp.millisecondsSinceEpoch,
    });

    await _firestore
        .collection('users')
        .doc(friendId)
        .collection('friends')
        .doc(userId)
        .update({
      'lastMessage': text,
      'lastMessageTime': timestamp.millisecondsSinceEpoch,
    });
  }

  String _getChatId(String userId, String friendId) {
    // Create a consistent chat ID by sorting user IDs
    final sortedIds = [userId, friendId]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }
}
