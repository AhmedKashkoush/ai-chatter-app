import 'package:ai_chatter/core/utils/utils.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class BaseChatRemoteDataSource {
  Future<GenerateContentResponse> generateResponse(String message);
  Future<List<String>> generateSuggestionsFrom(String response);
}

class ChatRemoteDataSource implements BaseChatRemoteDataSource {
  final GenerativeModel model;

  const ChatRemoteDataSource(this.model);
  @override
  Future<GenerateContentResponse> generateResponse(String message) async {
    return await AppUtils.generateResponse(model, message);
  }

  @override
  Future<List<String>> generateSuggestionsFrom(String response) async {
    return [];
  }
}
