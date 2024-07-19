import 'package:ai_chatter/app.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await initLocator();
  runApp(const AiChatterApp());
}
