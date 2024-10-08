import 'package:ai_chatter/config/other/chat_settings.dart';
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
    final Either<Failure, ChatSession> result = await clearChatHistoryUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          requestState: RequestState.failure,
          error: failure.message,
        ),
      ),
      (session) => emit(
        state.copyWith(
          requestState: RequestState.success,
          messages: [],
          suggestions: [],
          session: session,
        ),
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

  void getCachedMessages() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final Either<Failure, (List<MessageModel>, ChatSession)> result =
        getCachedChatUseCase();
    result.fold(
      (failure) => state.copyWith(
        messages: [],
      ),
      (response) {
        emit(
          state.copyWith(
            messages: response.$1,
            cacheLoaded: true,
            session: response.$2,
          ),
        );
        if (state.messages.last.isMe) return;
        _generateSuggestions(state.messages.last.message);
      },
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
        await generateResponseUseCase(message.message, state.session);

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
                message: response.text!.trim(),
                isMe: false,
                time: DateTime.now(),
              ),
            ],
            requestState: RequestState.success,
          ),
        );
        _generateSuggestions(response.text!);
      },
    );
    _cacheChat();
  }

  Future<void> _generateSuggestions(String response) async {
    if (!ChatSettings.suggestionsEnabled) return;
    Either<Failure, List<String>> result =
        await generateSuggestionsUseCase(response);
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
