import 'package:ai_chatter/core/errors/exceptions.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  static Future<void> checkConnectivity(Connectivity connectivity) async {
    final ConnectivityResult result =
        (await connectivity.checkConnectivity()).first;
    if (result == ConnectivityResult.none) {
      throw const NetworkException(message: AppStrings.checkConnectivity);
    }
  }

  static Future<GenerateContentResponse> generateResponse(
    GenerativeModel model,
    String prompt,
  ) async {
    try {
      final List<Content> content = [Content.text(prompt)];
      final GenerateContentResponse response =
          await model.generateContent(content);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static void share(String text) {
    Share.share(text);
  }
}
