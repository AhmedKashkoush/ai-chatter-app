import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/images.dart';
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
        child: Row(
          mainAxisAlignment:
              message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!message.isMe) ...[
              Image.asset(
                Images.appLogo,
                width: 40,
              ),
              5.w,
            ],
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                color: message.isMe
                    ? context.colorScheme.primary
                    : context.colorScheme.onBackground.withOpacity(0.2),
              ),
              child: SelectableText(
                message.message,
                style: TextStyle(
                  color: message.isMe ? context.colorScheme.background : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
