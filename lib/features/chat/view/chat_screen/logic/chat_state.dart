part of 'chat_cubit.dart';

class ChatState {
  final List<MessageModel> messages;
  final RequestState requestState;
  final String error;

  const ChatState({
    this.messages = const [],
    this.requestState = RequestState.initial,
    this.error = '',
  });

  ChatState copyWith({
    List<MessageModel>? messages,
    RequestState? requestState,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      requestState: requestState ?? this.requestState,
      error: error ?? this.error,
    );
  }
}
