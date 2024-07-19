import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/keys.dart';
import 'package:ai_chatter/core/widgets/error_screen.dart';
import 'package:ai_chatter/features/chat/view/chat_screen.dart';
import 'package:ai_chatter/features/introduction/introduction_screen.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  static const String initialRoute = AppRoutes.intro;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.intro:
        final SharedPreferences prefs = locator<SharedPreferences>();
        if (prefs.getBool(AppKeys.passedIntro) ?? false) {
          return MaterialPageRoute(
            builder: (_) => const ChatScreen(),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const IntroductionScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(),
        );
    }
  }
}
