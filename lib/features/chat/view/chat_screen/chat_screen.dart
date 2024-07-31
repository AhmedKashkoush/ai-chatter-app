import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/extensions/media_query_extension.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';

import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';

import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/chat_field.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/message_item.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/message_loading.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/scroll_to_bottom_button.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/widgets/start_chat_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _scrollPositionsListener =
      ItemPositionsListener.create();
  final ValueNotifier<bool> _showScrollButton = ValueNotifier<bool>(false);

  bool _keyboardShown = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<ChatCubit>().getCachedMessages();
    _scrollPositionsListener.itemPositions.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    if (!context.mounted) return;
    if (_scrollController.isAttached) {
      _showScrollButton.value =
          _scrollPositionsListener.itemPositions.value.last.index <
              context.read<ChatCubit>().state.messages.length - 1;
    }
  }

  @override
  void didChangeMetrics() {
    final double bottomInsets = View.of(context).viewInsets.bottom;
    final bool keyboardShown = bottomInsets > 0;
    if (keyboardShown != _keyboardShown) {
      _keyboardShown = keyboardShown;
      _scrollListener();
      if (_keyboardShown) {
        _scrollToBottom(force: !_showScrollButton.value, animate: false);
      }
    }
    super.didChangeMetrics();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _messageController.dispose();
    _showScrollButton.dispose();
    _scrollPositionsListener.itemPositions.removeListener(_scrollListener);
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
            context.tr(AppStrings.appName),
            style: context.textTheme.titleLarge,
          ),
        ),
        actions: [
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return IconButton(
                tooltip: context.tr(AppStrings.settings),
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
                  if (state.requestState != RequestState.initial) {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollToBottom(
                        force: !_showScrollButton.value,
                        loading: state.requestState == RequestState.loading,
                      );
                    });
                  }
                },
                builder: (context, state) {
                  if (state.messages.isEmpty) {
                    return const StartChatWidget();
                  }
                  return Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      ScrollablePositionedList.separated(
                        key: const ValueKey<String>('chat-list'),
                        itemScrollController: _scrollController,
                        itemPositionsListener: _scrollPositionsListener,
                        minCacheExtent: 1000,
                        initialScrollIndex: state.messages.length - 1,
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
                  _scrollToBottom(force: !_showScrollButton.value);
                }
              },
              builder: (context, state) {
                if (state.suggestions.isEmpty) return 8.h;
                return SizedBox(
                  height: 64,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return OutlinedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _messageController.text =
                              state.suggestions[index].trim();
                        },
                        child: Text(
                          state.suggestions[index].trim(),
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

  void _scrollToBottom({
    bool animate = true,
    force = false,
    loading = false,
  }) async {
    final ChatCubit cubit = context.read<ChatCubit>();
    if (!_scrollController.isAttached) {
      return;
    }
    if (!force) {
      return;
    }
    if (!animate) {
      _scrollController.jumpTo(
        index: loading
            ? cubit.state.messages.length
            : cubit.state.messages.length - 1,
        alignment: 0,
      );
      return;
    }

    _scrollController.scrollTo(
      index: loading
          ? cubit.state.messages.length
          : cubit.state.messages.length - 1,
      alignment: 0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  void _onSend(BuildContext context, String message) {
    context.read<ChatCubit>().sendMessage(
          MessageModel(
            message: message.trim(),
            isMe: true,
            time: DateTime.now(),
          ),
        );
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom(force: true);
    });
    _messageController.clear();
  }

  void _goToSettings(BuildContext context) {
    context.pushNamed(AppRoutes.settings);
  }
}
