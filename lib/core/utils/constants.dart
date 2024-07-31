import 'package:ai_chatter/core/utils/env_keys.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String apiKey = dotenv.env[EnvKeys.apiKey] ?? '';
  static const String modelName = 'gemini-1.5-flash-latest';
  static const String appName = 'AI Chatter';
  static const String appVersion = 'v1.0.0';
  static const String logoTag = 'logo';
  static const String myLinkedIn =
      'https://www.linkedin.com/in/ahmed-kashkoush-35b85a204/';
  static const String myGitHub = 'https://github.com/AhmedKashkoush/';
  static String suggestionsPrompt(String response) =>
      "Suggest me 4 options to respond to this message: $response. then list them as a series of strings separated by ',' but not the last one to display on a list of buttons to prompt the suggestion on tap. only respond by this list.";
}
