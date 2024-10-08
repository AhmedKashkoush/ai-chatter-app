import 'package:ai_chatter/core/errors/exceptions.dart' as ex;
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/core/utils/utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseChatRemoteDataSource {
  Future<GenerateContentResponse> generateResponse(String message);
  Future<GenerateContentResponse> sendMessage(
      String message, ChatSession? session);
  Future<List<String>> generateSuggestionsFrom(String response);
}

class ChatRemoteDataSource implements BaseChatRemoteDataSource {
  final GenerativeModel model;
  final Connectivity connectivity;
  final SharedPreferences prefs;

  const ChatRemoteDataSource(
    this.model,
    this.connectivity,
    this.prefs,
  );
  @override
  Future<GenerateContentResponse> generateResponse(String message) async {
    await AppUtils.checkConnectivity(connectivity);
    return await AppUtils.generateResponse(model, message).timeout(
      const Duration(seconds: 30),
      onTimeout: () => throw const ex.ServerException(
        message: AppStrings.responseTimeout,
      ),
    );
  }

  @override
  Future<GenerateContentResponse> sendMessage(
    String message,
    ChatSession? session,
  ) async {
    await AppUtils.checkConnectivity(connectivity);

    session = session ?? model.startChat();

    return await AppUtils.sendMessage(session, message)
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw const ex.ServerException(
            message: AppStrings.responseTimeout,
          ),
        )
        .catchError(
          (e) => throw const ex.ServerException(
            message: AppStrings.responseTimeout,
          ),
        );
  }

  @override
  Future<List<String>> generateSuggestionsFrom(String response) async {
    final GenerateContentResponse data = await AppUtils.generateResponse(
      model,
      AppConstants.suggestionsPrompt(response),
    );
    final List<String> suggestions = data.text
            ?.trim()
            .replaceAll('"', '')
            .split(',')
            .map((suggestion) => suggestion.trim())
            .where((suggestion) => suggestion.isNotEmpty)
            .toList() ??
        [];
    return suggestions;
  }
}
