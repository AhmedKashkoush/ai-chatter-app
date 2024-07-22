class MessageModel {
  final String message;
  final bool isMe;
  final DateTime time;
  const MessageModel({
    required this.message,
    required this.isMe,
    required this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      isMe: json['isMe'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'isMe': isMe,
        'time': time.toIso8601String(),
      };
}
