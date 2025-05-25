class ChatMessage {
  final String text;
  final bool isMe;
  final DateTime time;
  bool isRead;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
  });
} 