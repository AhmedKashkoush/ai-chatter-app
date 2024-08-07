import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ClearChatHistoryUseCase {
  final BaseChatRepository baseChatRepository;

  const ClearChatHistoryUseCase(this.baseChatRepository);

  Future<Either<Failure, ChatSession>> call() async {
    return await baseChatRepository.clearChatHistory();
  }
}
