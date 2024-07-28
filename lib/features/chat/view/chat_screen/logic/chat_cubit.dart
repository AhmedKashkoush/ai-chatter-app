import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/usecases/cache_chat_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/clear_chat_history_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_response_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_suggestions_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/get_cached_chat_usecase.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GenerateResponseUseCase generateResponseUseCase;
  final GenerateSuggestionsUseCase generateSuggestionsUseCase;
  final CacheChatUseCase cacheChatUseCase;
  final GetCachedChatUseCase getCachedChatUseCase;
  final ClearChatHistoryUseCase clearChatHistoryUseCase;
  ChatCubit(
    this.generateResponseUseCase,
    this.generateSuggestionsUseCase,
    this.cacheChatUseCase,
    this.getCachedChatUseCase,
    this.clearChatHistoryUseCase,
  ) : super(
          const ChatState(
            requestState: RequestState.initial,
          ),
        );

  void clearChatHistory() async {
    final Either<Failure, Unit> result = await clearChatHistoryUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          requestState: RequestState.failure,
          error: failure.message,
        ),
      ),
      (_) => emit(
        state.copyWith(
            requestState: RequestState.success, messages: [], suggestions: []),
      ),
    );
  }

  void clearSuggestions() {
    emit(
      state.copyWith(
        suggestions: [],
      ),
    );
  }

  void getCachedMessages() {
    final Either<Failure, List<MessageModel>> result = getCachedChatUseCase();
    result.fold(
      (failure) => state.copyWith(
        messages: [],
      ),
      (messages) => emit(
        state.copyWith(
          messages: messages,
          cacheLoaded: true,
        ),
      ),
    );
  }

  void sendMessage(MessageModel message) async {
    emit(
      state.copyWith(
        messages: [...state.messages, message],
        suggestions: [],
      ),
    );
    await Future.delayed(
      const Duration(
        milliseconds: 600,
      ),
    );
    emit(
      state.copyWith(
        requestState: RequestState.loading,
      ),
    );

    final Either<Failure, GenerateContentResponse> result =
        await generateResponseUseCase(message.message);

    result.fold(
      (failure) {
        final MessageModel errorMessage = MessageModel(
          message: failure.message,
          isMe: false,
          time: DateTime.now(),
          hasError: true,
          prompt: message.message,
        );
        emit(
          state.copyWith(
            requestState: RequestState.failure,
            error: failure.message,
            messages: [
              ...state.messages,
              errorMessage,
            ],
          ),
        );
      },
      (response) async {
        emit(
          state.copyWith(
            messages: [
              ...state.messages,
              MessageModel(
                message: response.text!,
                isMe: false,
                time: DateTime.now(),
              ),
            ],
            requestState: RequestState.success,
          ),
        );
        _generateSuggestions(response);
      },
    );
    _cacheChat();
  }

  Future<void> _generateSuggestions(GenerateContentResponse response) async {
    Either<Failure, List<String>> result =
        await generateSuggestionsUseCase(response.text!);
    result.fold(
      (l) => null,
      (suggestions) => emit(
        state.copyWith(suggestions: suggestions),
      ),
    );
  }

  void deleteMessage(MessageModel messageToDelete) {
    final List<MessageModel> messages = state.messages;
    messages.removeWhere((message) => messageToDelete.time == message.time);
    emit(state.copyWith(
      messages: messages,
    ));

    _cacheChat();
  }

  void _cacheChat() async {
    await cacheChatUseCase(state.messages);
  }
}
