import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/keys.dart';
import 'package:ai_chatter/core/strings.dart';
import 'package:ai_chatter/core/widgets/custom_elevated_button.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartChattingButton extends StatelessWidget {
  const StartChattingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: () => _startChatting(context),
      text: AppStrings.startChatting,
    );
  }

  void _startChatting(BuildContext context) {
    _setIntroPassed().then(
      (_) => context.pushReplacementNamed(AppRoutes.home),
    );
  }

  Future<void> _setIntroPassed() async {
    SharedPreferences prefs = locator<SharedPreferences>();
    await prefs.setBool(AppKeys.passedIntro, true);
  }
}
