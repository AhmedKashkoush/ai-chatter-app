import 'package:google_generative_ai/google_generative_ai.dart';

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
}
