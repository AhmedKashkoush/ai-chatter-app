import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleSettings {
  static bool get useSystemLocale =>
      locator<SharedPreferences>().getBool(AppKeys.useSystemLocale) ?? true;

  static Future<void> setUseSystemLocale(bool value) async {
    await locator<SharedPreferences>().setBool(AppKeys.useSystemLocale, value);
  }
}
