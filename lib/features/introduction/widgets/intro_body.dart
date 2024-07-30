import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class IntroBody extends StatelessWidget {
  const IntroBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      context.tr(
        AppStrings.introBody,
        namedArgs: {
          AppStrings.appName: context.tr(AppStrings.appName),
        },
      ),
      textAlign: TextAlign.center,
      style: context.textTheme.bodyMedium?.copyWith(
        color: Colors.grey,
      ),
    );
  }
}
