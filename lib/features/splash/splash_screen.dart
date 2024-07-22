import 'dart:async';
import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), _initialize);
    super.initState();
  }

  FutureOr<void> _initialize() async {
    final SharedPreferences prefs = locator<SharedPreferences>();
    if (prefs.getBool(AppKeys.passedIntro) ?? false) {
      context.pushReplacementNamed(AppRoutes.home);
    } else {
      context.pushReplacementNamed(AppRoutes.intro);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: AppLogo(),
      ),
    );
  }
}
