import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';

import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/constants.dart';

import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/logic/chat_cubit.dart';
import 'package:ai_chatter/features/chat/view/widgets/chat_field.dart';
import 'package:ai_chatter/features/chat/view/widgets/message_item.dart';
import 'package:ai_chatter/features/chat/view/widgets/message_loading.dart';
import 'package:ai_chatter/features/chat/view/widgets/scroll_to_bottom_button.dart';
import 'package:ai_chatter/features/chat/view/widgets/start_chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollButton = ValueNotifier<bool>(false);

  final int _limit = 100;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (!context.mounted) return;
    if (_scrollController.hasClients) {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - _limit) {
        _showScrollButton.value = false;
      } else {
        _showScrollButton.value = true;
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _showScrollButton.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          leading: const AppLogo(size: 40),
          title: Text(
            AppConstants.appName,
            style: context.textTheme.titleLarge,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _goToSettings(context),
            icon: const Icon(CupertinoIcons.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  switch (state.requestState) {
                    case RequestState.success:
                    case RequestState.loading:
                    case RequestState.failure:
                      _scrollToBottom();
                      break;
                    default:
                      return;
                  }
                },
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return const StartChatWidget();
                  }
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        itemCount: state.requestState == RequestState.loading
                            ? state.messages.length + 1
                            : state.messages.length,
                        itemBuilder: (context, index) {
                          if (index == state.messages.length) {
                            return const MessageLoading();
                          }
                          return MessageItem(
                            message: state.messages[index],
                          );
                        },
                      ),
                      Positioned(
                        bottom: 8,
                        child: ScrollToBottomButton(
                          showScrollButton: _showScrollButton,
                          onPressed: _forceToScrollToBottom,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ChatField(
              controller: _messageController,
              onSend: () => _onSend(context),
            )
          ],
        ),
      ),
    );
  }

  void _forceToScrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) {
        return;
      }
      if (_scrollController.position.pixels <=
          _scrollController.position.maxScrollExtent - _limit) {
        return;
      }
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    });
  }

  void _onSend(BuildContext context) {
    context.read<ChatCubit>().sendMessage(
          MessageModel(
            message: _messageController.text,
            isMe: true,
            time: DateTime.now(),
          ),
        );
    _messageController.clear();
    _forceToScrollToBottom();
  }

  void _goToSettings(BuildContext context) {
    context.pushNamed(AppRoutes.settings);
  }
}
