import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/images.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:flutter/material.dart';

class StartChatWidget extends StatelessWidget {
  const StartChatWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            Images.appLogo,
            width: 100,
          ),
          10.h,
          Text(
            AppStrings.whatIsOnYourMind,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
