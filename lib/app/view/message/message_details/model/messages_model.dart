enum MessageType { text, image, video, audio }

class Message {
  final String content;
  final bool isSent;
  final MessageType type;
  final String time;
  final int status;
  final DateTime dateTime;
  String? reaction; // Add this line

  Message({
    required this.content,
    required this.isSent,
    required this.type,
    required this.time,
    required this.status,
    required this.dateTime,
    this.reaction,
  });
}

