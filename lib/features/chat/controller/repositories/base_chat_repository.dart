import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class BaseChatRepository {
  Future<Either<Failure, GenerateContentResponse>> generateResponse(
      String message);
  Future<Either<Failure, List<String>>> generateSuggestionsFrom(
      String response);
  Future<Either<Failure, Unit>> cacheChat(List<MessageModel> messages);
  Either<Failure, List<MessageModel>> getCachedChat();
  Future<Either<Failure, Unit>> clearChatHistory();
}
