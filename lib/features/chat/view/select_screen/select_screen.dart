import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:flutter/material.dart';

class SelectScreen extends StatelessWidget {
  final MessageModel message;
  const SelectScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SelectableText(message.message),
      ),
    );
  }
}
