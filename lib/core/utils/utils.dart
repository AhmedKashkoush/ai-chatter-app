import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:share_plus/share_plus.dart';

class AppUtils {
  static Future<GenerateContentResponse> generateResponse(
    GenerativeModel model,
    String prompt,
  ) async {
    final List<Content> content = [Content.text(prompt)];
    final GenerateContentResponse response =
        await model.generateContent(content);
    return response;
  }

  static void copy(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  static void share(String text) {
    Share.share(text);
  }
}
