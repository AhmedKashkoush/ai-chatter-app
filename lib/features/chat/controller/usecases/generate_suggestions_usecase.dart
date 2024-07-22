import 'package:ai_chatter/core/errors/failures.dart';
import 'package:ai_chatter/features/chat/controller/repositories/base_chat_repository.dart';
import 'package:dartz/dartz.dart';

class GenerateSuggestionsUseCase {
  final BaseChatRepository baseChatRepository;

  const GenerateSuggestionsUseCase(this.baseChatRepository);

  Future<Either<Failure, List<String>>> call(String response) async {
    return await baseChatRepository.generateSuggestionsFrom(response);
  }
}
