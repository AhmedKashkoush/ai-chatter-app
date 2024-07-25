import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String apiKey = dotenv.env['API_KEY'] ?? '';
  static const String modelName = 'gemini-1.5-flash-latest';
  static const String appName = 'Ai Chatter';
  static const String logoTag = 'logo';
  static const String initialPrompt = 'Act as your name is Sparky';
}
