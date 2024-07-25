import 'package:ai_chatter/config/routes/routes.dart';

import 'package:ai_chatter/core/widgets/error_screen.dart';
import 'package:ai_chatter/features/chat/model/models/message_model.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/chat_screen.dart';
import 'package:ai_chatter/features/chat/view/select_screen/select_screen.dart';
import 'package:ai_chatter/features/introduction/introduction_screen.dart';
import 'package:ai_chatter/features/settings/settings_screen.dart';
import 'package:ai_chatter/features/splash/splash_screen.dart';

import 'package:flutter/material.dart';

class AppRouter {
  static const String initialRoute = AppRoutes.splash;
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );
      case AppRoutes.intro:
        return MaterialPageRoute(
          builder: (_) => const IntroductionScreen(),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );
      case AppRoutes.select:
        return MaterialPageRoute(
          builder: (_) => SelectScreen(
            message: settings.arguments as MessageModel,
          ),
        );
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(),
        );
    }
  }
}
