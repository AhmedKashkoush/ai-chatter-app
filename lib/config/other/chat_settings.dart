import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatSettings {
  static bool get suggestionsEnabled =>
      locator<SharedPreferences>().getBool(AppKeys.suggestions) ?? true;

  static Future<void> setSuggestionsEnabled(bool value) async =>
      await locator<SharedPreferences>().setBool(AppKeys.suggestions, value);
}
