import 'package:ai_chatter/core/errors/exceptions.dart';
import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:ai_chatter/features/chat/model/data_sources/local/chat_local_data_source.dart';
import 'package:ai_chatter/features/chat/model/data_sources/remote/chat_remote_data_source.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as ai;

class ChatRepository implements BaseChatRepository {
  final BaseChatRemoteDataSource remoteDataSource;
  final BaseChatLocalDataSource localDataSource;

  const ChatRepository(
      {required this.remoteDataSource, required this.localDataSource});
  @override
  Future<Either<Failure, Unit>> cacheChat(List<MessageModel> messages) async {
    try {
      await localDataSource.cacheChat(messages);
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ai.GenerateContentResponse>> generateResponse(
      String message, ai.ChatSession? session) async {
    try {
      final ai.GenerateContentResponse response =
          await remoteDataSource.sendMessage(message, session);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          message: e.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
        ),
      );
    } catch (e) {
      return const Left(
        ServerFailure(
          message: AppStrings.responseTimeout,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<String>>> generateSuggestionsFrom(
      String response) async {
    try {
      final List<String> suggestions =
          await remoteDataSource.generateSuggestionsFrom(response);
      return Right(suggestions);
    } on NetworkException catch (e) {
      return Left(
        NetworkFailure(
          message: e.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
        ),
      );
    } catch (e) {
      return const Left(
        ServerFailure(
          message: AppStrings.responseTimeout,
        ),
      );
    }
  }

  @override
  Either<Failure, (List<MessageModel>, ai.ChatSession)> getCachedChat() {
    try {
      final (List<MessageModel>, ai.ChatSession) messages =
          localDataSource.getCachedChat();
      return Right(messages);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          message: e.message,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, ai.ChatSession>> clearChatHistory() async {
    try {
      final ai.ChatSession session = await localDataSource.clearChatHistory();
      return Right(session);
    } on CacheException catch (e) {
      return Left(
        CacheFailure(
          message: e.message,
        ),
      );
    }
  }
}
