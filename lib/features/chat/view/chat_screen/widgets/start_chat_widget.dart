import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:easy_localization/easy_localization.dart';
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
          const AppLogo(size: 100),
          10.h,
          Text(
            context.tr(AppStrings.whatIsOnYourMind),
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
