import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/lotties.dart';
import 'package:ai_chatter/core/widgets/orientation_widget.dart';
import 'package:ai_chatter/features/introduction/widgets/intro_body.dart';
import 'package:ai_chatter/features/introduction/widgets/intro_title.dart';
import 'package:ai_chatter/features/introduction/widgets/start_chatting_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

part 'layout/introduction_screen_portrait.dart';
part 'layout/introduction_screen_landscape.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = context.colorScheme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: () {
            context.read<ThemeCubit>().themeMode =
                isDark ? ThemeMode.light : ThemeMode.dark;
          },
          icon: Icon(isDark ? CupertinoIcons.brightness : CupertinoIcons.moon),
        ),
      ]),
      body: const OrientationWidget(
        portrait: _IntroductionScreenPortrait(),
        landscape: _IntroductionScreenLandscape(),
      ),
    );
  }
}
