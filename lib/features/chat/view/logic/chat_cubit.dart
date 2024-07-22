import 'package:ai_chatter/core/enums/request_state.dart';
import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/usecases/cache_chat_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_response_usecase.dart';
import 'package:ai_chatter/features/chat/controller/usecases/generate_suggestions_usecase.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GenerateResponseUseCase generateResponseUseCase;
  final GenerateSuggestionsUseCase generateSuggestionsUseCase;
  final CacheChatUseCase cacheChatUseCase;
  ChatCubit(
    this.generateResponseUseCase,
    this.generateSuggestionsUseCase,
    this.cacheChatUseCase,
  ) : super(
          const ChatState(
            requestState: RequestState.initial,
          ),
        );

  void sendMessage(MessageModel message) async {
    emit(
      state.copyWith(
        messages: [...state.messages, message],
        requestState: RequestState.loading,
      ),
    );

    final Either<Failure, GenerateContentResponse> result =
        await generateResponseUseCase(message.message);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            requestState: RequestState.failure,
            error: failure.message,
          ),
        );
      },
      (response) {
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
      },
    );
  }
}
