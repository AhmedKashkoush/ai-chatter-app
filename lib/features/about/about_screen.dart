import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/widgets/app_logo.dart';
import 'package:ai_chatter/core/widgets/orientation_widget.dart';
import 'package:ai_chatter/features/about/widgets/contacts_section.dart';
import 'package:ai_chatter/features/about/widgets/description_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/utils/strings.dart';

part './layout/about_screen_portrait.dart';
part './layout/about_screen_landscape.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.aboutTheApp),
        ),
      ),
      body: const OrientationWidget(
        portrait: AboutScreenPortrait(),
        landscape: AboutScreenLandscape(),
      ),
    );
  }
}
