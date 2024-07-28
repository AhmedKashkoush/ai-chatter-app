import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String modelName = 'gemini-1.5-flash-latest';
  static const String appName = 'Ai Chatter';
  static const String logoTag = 'logo';
  static const String initialPrompt = 'Act as your name is Sparky';
  static String suggestionsPrompt(String response) =>
      "Suggest me 4 options to respond to this message: $response. then list them as a series of strings separated by ',' but not the last one to display on a list of buttons to prompt the suggestion on tap. only respond by this list.";
}
