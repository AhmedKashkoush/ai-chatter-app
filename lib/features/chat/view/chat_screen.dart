import 'package:ai_chatter/core/constants.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          const AppLogo(size: 40),
          10.w,
          Text(
            AppConstants.appName,
            style: context.textTheme.titleLarge,
          ),
        ]),
      ),
    );
  }
}
