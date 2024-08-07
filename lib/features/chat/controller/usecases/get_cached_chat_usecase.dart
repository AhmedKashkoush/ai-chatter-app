import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GetCachedChatUseCase {
  final BaseChatRepository baseChatRepository;

  const GetCachedChatUseCase(this.baseChatRepository);

  Either<Failure, (List<MessageModel>, ChatSession)> call() {
    return baseChatRepository.getCachedChat();
  }
}
