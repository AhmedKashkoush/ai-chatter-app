import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsSection extends StatelessWidget {
  const ContactsSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr(AppStrings.forContact),
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        10.h,
        ListTile(
          leading: const Icon(Ionicons.logo_linkedin),
          textColor: context.colorScheme.primary,
          title: const Text(AppConstants.myLinkedIn),
          onTap: () {
            _openUrl(AppConstants.myLinkedIn);
          },
        ),
        ListTile(
          leading: const Icon(Ionicons.logo_github),
          textColor: context.colorScheme.primary,
          title: const Text(AppConstants.myGitHub),
          onTap: () {
            _openUrl(AppConstants.myGitHub);
          },
        ),
      ],
    );
  }

  void _openUrl(String url) {
    launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }
}
