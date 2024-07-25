import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';

class GetCachedChatUseCase {
  final BaseChatRepository baseChatRepository;

  const GetCachedChatUseCase(this.baseChatRepository);

  Either<Failure, List<MessageModel>> call() {
    return baseChatRepository.getCachedChat();
  }
}
