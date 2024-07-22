import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';

class CacheChatUseCase {
  final BaseChatRepository baseChatRepository;

  const CacheChatUseCase(this.baseChatRepository);

  Future<Either<Failure, Unit>> call(List<MessageModel> messages) async {
    return await baseChatRepository.cacheChat(messages);
  }
}
