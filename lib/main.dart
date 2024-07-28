import 'package:ai_chatter/app.dart';
import 'package:ai_chatter/config/locales/locales.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initLocator();
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: AppLocales.assetPath,
      fallbackLocale: AppLocales.supportedLocales.first,
      child: const AiChatterApp(),
    ),
  );
}
