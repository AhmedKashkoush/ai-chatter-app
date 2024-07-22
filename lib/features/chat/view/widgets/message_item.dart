import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/popup_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/images.dart';

import 'package:ai_chatter/core/utils/utils.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  const MessageItem({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        if (message.isMe)
          BubbleSpecialOne(
            text: message.message,
            isSender: message.isMe,
            textStyle: TextStyle(
              color: context.colorScheme.background,
            ),
            tail: true,
            color: context.colorScheme.primary,
          )
        else
          PopupMenuButton<PopupMenuEntry<dynamic>>(
            splashRadius: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            itemBuilder: (context) => _options(context),
            child: BubbleSpecialOne(
              text: message.message,
              isSender: message.isMe,
              tail: true,
              color: context.colorScheme.onBackground.withOpacity(0.3),
            ),
          ),
      ],
    );
  }

  List<PopupMenuEntry<PopupMenuEntry<dynamic>>> _options(BuildContext context) {
    return [
      PopupMenuItem(
        onTap: () => _onCopy(context),
        child: Row(
          children: [
            const Icon(Icons.copy),
            10.w,
            const Text('Copy'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        onTap: _onShare,
        child: Row(
          children: [
            const Icon(Icons.share),
            10.w,
            const Text('Share'),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        onTap: () => _onDelete(context),
        child: Row(
          children: [
            const Icon(Icons.delete, color: Colors.red),
            10.w,
            const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    ];
  }

  void _onCopy(BuildContext context) {
    AppUtils.copy(message.message);

    context.showSnackBar(message: 'Copied to clipboard');
  }

  void _onShare() {
    AppUtils.share(message.message);
  }

  void _onDelete(BuildContext context) async {
    bool confirm = await context.showConfirmDialog(
        message: 'Are you sure you want to delete this message?',
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text('Yes'),
          ),
        ]);

    if (confirm) {
      //delete
    }
  }
}
