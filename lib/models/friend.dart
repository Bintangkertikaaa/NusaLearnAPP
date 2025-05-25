import 'chat_message.dart';

class Friend {
  final String id;
  final String name;
  final String school;
  final String initials;
  final List<ChatMessage> messages;

  Friend({
    required this.id,
    required this.name,
    required this.school,
    required this.initials,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  String get lastMessage => messages.isNotEmpty ? messages.first.text : '';
  bool get hasUnreadMessages => messages.any((msg) => !msg.isMe && !msg.isRead);
  DateTime get lastMessageTime => messages.isNotEmpty ? messages.first.time : DateTime.fromMillisecondsSinceEpoch(0);

  void markAllMessagesAsRead() {
    for (var message in messages) {
      if (!message.isMe) {
        message.isRead = true;
      }
    }
  }
}