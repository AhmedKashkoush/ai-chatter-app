import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/extensions/media_query_extension.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';

import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/constants.dart';

import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/chat_field.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/message_item.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/message_loading.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/scroll_to_bottom_button.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/start_chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ValueNotifier<bool> _showScrollButton = ValueNotifier<bool>(false);

  bool _keyboardShown = false;

  final int _limit = 100;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<ChatCubit>().getCachedMessages();
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
  void didChangeMetrics() {
    final double bottomInsets = View.of(context).viewInsets.bottom;
    final bool keyboardShown = bottomInsets > 0;

    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - _limit) {
      _showScrollButton.value = false;
    }
    if (keyboardShown != _keyboardShown) {
      _keyboardShown = keyboardShown;
      if (_keyboardShown) {
        _scrollToBottom(animate: false);
      }
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _scrollController.dispose();
    _showScrollButton.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: ListTile(
          leading: const AppLogo(size: 40),
          title: Text(
            AppConstants.appName,
            style: context.textTheme.titleLarge,
          ),
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return IconButton(
                onPressed: state.requestState == RequestState.loading
                    ? null
                    : () => _goToSettings(context),
                icon: const Icon(CupertinoIcons.settings),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 12,
          left: 12,
          right: 12,
          bottom: 12 + context.bottomInsets,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state.cacheLoaded) {
                    _scrollToBottom(force: true);
                    return;
                  }
                  // _scrollToBottom();
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
                      ListView.separated(
                        controller: _scrollController,
                        cacheExtent: state.messages.length * 0.5,
                        itemCount: state.requestState == RequestState.loading
                            ? state.messages.length + 1
                            : state.messages.length,
                        separatorBuilder: (context, index) => 10.h,
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
                          onPressed: () => _scrollToBottom(force: true),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state.suggestions.isNotEmpty) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state.suggestions.isEmpty) return const SizedBox.shrink();
                return SizedBox(
                  height: 64,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _messageController.text = state.suggestions[index];
                        },
                        child: Text(
                          state.suggestions[index],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => 10.w,
                    itemCount: state.suggestions.length,
                  ),
                );
              },
            ),
            ChatField(
              controller: _messageController,
              onSend: () => _onSend(context, _messageController.text),
            )
          ],
        ),
      ),
    );
  }

  // void _forceToScrollToBottom() {
  //   if (!_scrollController.hasClients) {
  //     return;
  //   }
  //   if ((_scrollController.position.maxScrollExtent - _limit) -
  //           _scrollController.position.pixels <
  //       800) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.fastEaseInToSlowEaseOut,
  //     );
  //   } else {
  //     _scrollController.jumpTo(
  //       _scrollController.position.maxScrollExtent,
  //     );
  //   }
  // }

  void _scrollToBottom({bool animate = true, force = false}) async {
    if (!_scrollController.hasClients) {
      return;
    }
    if (!force) {
      await Future.delayed(const Duration(milliseconds: 400));
    }
    if (_showScrollButton.value && !force) {
      return;
    }
    if (!animate) {
      _scrollController.jumpTo(
        _scrollController.position.maxScrollExtent,
      );
    } else {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    }
  }

  void _onSend(BuildContext context, String message) {
    context.read<ChatCubit>().sendMessage(
          MessageModel(
            message: message.trim(),
            isMe: true,
            time: DateTime.now(),
          ),
        );

    _scrollToBottom(force: true);
    _messageController.clear();
  }

  void _goToSettings(BuildContext context) {
    context.pushNamed(AppRoutes.settings);
  }
}
