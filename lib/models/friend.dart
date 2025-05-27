import 'chat_message.dart';

class Friend {
  final String id;
  final String name;
  final String school;
  final int points;
  final String level;
  final String? photoUrl;
  final List<ChatMessage> messages;

  Friend({
    required this.id,
    required this.name,
    required this.school,
    required this.points,
    required this.level,
    this.photoUrl,
    List<ChatMessage>? messages,
  }) : messages = messages ?? [];

  String get lastMessage => messages.isNotEmpty ? messages.first.text : '';
  bool get hasUnreadMessages => messages.any((msg) => !msg.isMe && !msg.isRead);
  DateTime get lastMessageTime => messages.isNotEmpty
      ? messages.first.timestamp
      : DateTime.fromMillisecondsSinceEpoch(0);

  void markAllMessagesAsRead() {
    for (var message in messages) {
      if (!message.isMe) {
        message.isRead = true;
      }
    }
  }

  factory Friend.fromJson(Map<String, dynamic> data) {
    return Friend(
      id: data['id'],
      name: data['name'],
      school: data['school'],
      points: data['points'],
      level: data['level'] ?? 'Pemula',
      photoUrl: data['photoUrl'],
      messages: (data['messages'] as List<dynamic>?)
              ?.map((msg) => ChatMessage.fromJson(msg))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'school': school,
      'points': points,
      'level': level,
      'photoUrl': photoUrl,
      'messages': messages.map((msg) => msg.toJson()).toList(),
    };
  }
}
