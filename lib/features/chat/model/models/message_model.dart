class MessageModel {
  final String message, prompt;
  final bool isMe, hasError;
  final DateTime time;
  const MessageModel({
    required this.message,
    required this.isMe,
    required this.time,
    this.prompt = '',
    this.hasError = false,
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
