import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.aboutTitle, namedArgs: {
            AppStrings.appName: context.tr(AppStrings.appName),
          }),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        10.h,
        Text(
          context.tr(AppStrings.aboutDescription, namedArgs: {
            AppStrings.appName: context.tr(AppStrings.appName),
          }),
          style: context.textTheme.bodyLarge,
        ),
      ],
    );
  }
}
