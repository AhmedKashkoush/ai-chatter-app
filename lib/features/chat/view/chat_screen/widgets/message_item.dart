import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/extensions/media_query_extension.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/popup_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';

import 'package:ai_chatter/core/utils/utils.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/custom_markdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../../../core/widgets/app_logo.dart';

class MessageItem extends StatefulWidget {
  final MessageModel message;
  final bool canSelect;
  const MessageItem({
    super.key,
    required this.message,
    this.canSelect = false,
  });

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return widget.canSelect
        ? _MessageBody(widget: widget)
        : GestureDetector(
            onLongPress: () {
              HapticFeedback.vibrate();
              context.showMessageMenu(
                isMe: widget.message.isMe,
                items: widget.message.isMe
                    ? _userOptions(context)
                    : _aiOptions(context),
              );
            },
            child: _MessageBody(widget: widget),
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
              Text(context.tr(AppStrings.copy)),
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
              Text(
                context.tr(AppStrings.select),
              ),
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
              Text(
                context.tr(AppStrings.share),
              ),
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
              Text(
                context.tr(AppStrings.regenerate),
              ),
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
            Text(
              context.tr(AppStrings.delete),
              style: const TextStyle(color: Colors.red),
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
      message: context.tr(AppStrings.copiedToClipboard),
      icon: Icons.copy,
    );
  }

  void _onShare() {
    AppUtils.share(widget.message.message);
  }

  void _onDelete(BuildContext context) async {
    context.showConfirmDialog(
        message: context.tr(AppStrings.confirmToDeleteMessage),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              context.tr(AppStrings.no),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(
              context.tr(AppStrings.yes),
              style: const TextStyle(
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
            Text(
              context.tr(AppStrings.copy),
            ),
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
            Text(
              context.tr(AppStrings.select),
            ),
          ],
        ),
      ),
    ];
  }

  void _onSelect(BuildContext context) {
    context.pushNamed(AppRoutes.select, arguments: widget.message);
  }
}

class _MessageBody extends StatelessWidget {
  const _MessageBody({
    required this.widget,
  });

  final MessageItem widget;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      overlapHeaders: true,
      header: !widget.message.isMe
          ? Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const AppLogo(size: 40),
                5.w,
              ],
            )
          : const SizedBox.shrink(),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: widget.message.isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!widget.message.isMe) 45.w,
          Container(
            padding: const EdgeInsets.all(8),
            constraints: BoxConstraints(
              maxWidth: context.screenWidth * 0.8,
              // minWidth: context.screenWidth * 0.1,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(15),
              ),
              color: widget.message.isMe
                  ? context.colorScheme.primary
                  : context.colorScheme.onBackground.withOpacity(0.2),
            ),
            child: !widget.message.isMe && !widget.message.hasError
                ? CustomMarkdown(
                    data: widget.message.message,
                    isSelect: widget.canSelect,
                  )
                : widget.canSelect
                    ? SelectableText(
                        widget.message.hasError
                            ? context.tr(widget.message.message)
                            : widget.message.message,
                        style: TextStyle(
                          color: widget.message.isMe
                              ? context.colorScheme.background
                              : widget.message.hasError
                                  ? Colors.red
                                  : null,
                        ),
                      )
                    : Text(
                        widget.message.hasError
                            ? context.tr(widget.message.message)
                            : widget.message.message,
                        style: TextStyle(
                          color: widget.message.isMe
                              ? context.colorScheme.background
                              : widget.message.hasError
                                  ? Colors.red
                                  : null,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
