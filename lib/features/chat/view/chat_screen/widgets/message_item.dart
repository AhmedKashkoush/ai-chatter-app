import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/popup_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/images.dart';
import 'package:ai_chatter/core/utils/strings.dart';

import 'package:ai_chatter/core/utils/utils.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageItem extends StatefulWidget {
  final MessageModel message;
  const MessageItem({
    super.key,
    required this.message,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final GlobalKey<PopupMenuButtonState> _key =
      GlobalKey<PopupMenuButtonState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        HapticFeedback.vibrate();
        _key.currentState!.showButtonMenu();
      },
      child: PopupMenuButton(
        key: _key,
        enableFeedback: false,
        position: PopupMenuPosition.under,
        offset: const Offset(1, 2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        itemBuilder: (context) =>
            widget.message.isMe ? _userOptions(context) : _aiOptions(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.message.isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!widget.message.isMe) ...[
              Image.asset(
                Images.appLogo,
                width: 40,
              ),
              5.w,
            ],
            BubbleSpecialOne(
              text: widget.message.message,
              isSender: widget.message.isMe,
              textStyle: TextStyle(
                color: widget.message.isMe
                    ? context.colorScheme.background
                    : widget.message.hasError
                        ? Colors.red
                        : null,
              ),
              tail: true,
              color: widget.message.isMe
                  ? context.colorScheme.primary
                  : context.colorScheme.onBackground.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<PopupMenuEntry<dynamic>>> _aiOptions(
      BuildContext context) {
    return [
      if (!widget.message.hasError) ...[
        PopupMenuItem(
          onTap: () => _onCopy(context),
          child: Row(
            children: [
              const Icon(Icons.copy),
              10.w,
              const Text(AppStrings.copy),
            ],
          ),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          onTap: () => _onSelect(context),
          child: Row(
            children: [
              const Icon(Icons.select_all),
              10.w,
              const Text(AppStrings.select),
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
              const Text(AppStrings.share),
            ],
          ),
        ),
      ] else
        PopupMenuItem(
          onTap: () => _onRegenerate(context),
          child: Row(
            children: [
              const Icon(Icons.loop),
              10.w,
              const Text(AppStrings.regenerate),
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
              AppStrings.delete,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    ];
  }

  void _onRegenerate(BuildContext context) {
    final MessageModel message = MessageModel(
      message: widget.message.prompt,
      isMe: true,
      time: DateTime.now(),
    );
    context.read<ChatCubit>().sendMessage(message);
  }

  void _onCopy(BuildContext context) {
    AppUtils.copy(widget.message.message);

    context.showSnackBar(
      message: AppStrings.copiedToClipboard,
      icon: Icons.copy,
    );
  }

  void _onShare() {
    AppUtils.share(widget.message.message);
  }

  void _onDelete(BuildContext context) async {
    context.showConfirmDialog(
        message: AppStrings.confirmToDeleteMessage,
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(AppStrings.no),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: const Text(
              AppStrings.yes,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ]).then(
      (confirm) {
        if (confirm) {
          context.read<ChatCubit>().deleteMessage(widget.message);
        }
      },
    );
  }

  List<PopupMenuEntry<PopupMenuEntry<dynamic>>> _userOptions(
      BuildContext context) {
    return [
      PopupMenuItem(
        onTap: () => _onCopy(context),
        child: Row(
          children: [
            const Icon(Icons.copy),
            10.w,
            const Text(AppStrings.copy),
          ],
        ),
      ),
      const PopupMenuDivider(),
      PopupMenuItem(
        onTap: () => _onSelect(context),
        child: Row(
          children: [
            const Icon(Icons.select_all),
            10.w,
            const Text(AppStrings.select),
          ],
        ),
      ),
    ];
  }

  void _onSelect(BuildContext context) {
    context.pushNamed(AppRoutes.select, arguments: widget.message);
  }
}
