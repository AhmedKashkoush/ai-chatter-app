import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/lotties.dart';
import 'package:ai_chatter/core/strings.dart';
import 'package:ai_chatter/core/widgets/orientation_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

part 'layout/introduction_screen_portrait.dart';
part 'layout/introduction_screen_landscape.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrientationWidget(
      portrait: _IntroductionScreenPortrait(),
      landscape: _IntroductionScreenLandscape(),
    );
  }
}
