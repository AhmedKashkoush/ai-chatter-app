part of 'chat_cubit.dart';

class ChatState {
  final List<MessageModel> messages;
  final List<String> suggestions;
  final RequestState requestState;
  final String error;
  final bool cacheLoaded;
  final ChatSession? session;

  const ChatState({
    this.messages = const [],
    this.suggestions = const [],
    this.requestState = RequestState.initial,
    this.error = '',
    this.cacheLoaded = false,
    this.session,
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    List<String>? suggestions,
    RequestState? requestState,
    String? error,
    bool? cacheLoaded,
    ChatSession? session,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      suggestions: suggestions ?? this.suggestions,
      requestState: requestState ?? this.requestState,
      error: error ?? this.error,
      cacheLoaded: cacheLoaded ?? this.cacheLoaded,
      session: session ?? this.session,
    );
  }
}
