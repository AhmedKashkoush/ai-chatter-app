import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerateResponseUseCase {
  final BaseChatRepository baseChatRepository;

  const GenerateResponseUseCase(this.baseChatRepository);

  Future<Either<Failure, GenerateContentResponse>> call(String message) async {
    return await baseChatRepository.generateResponse(message);
  }
}
