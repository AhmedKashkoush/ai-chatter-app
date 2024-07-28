import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:dartz/dartz.dart';

class ClearChatHistoryUseCase {
  final BaseChatRepository baseChatRepository;

  const ClearChatHistoryUseCase(this.baseChatRepository);

  Future<Either<Failure, Unit>> call() async {
    return await baseChatRepository.clearChatHistory();
  }
}
