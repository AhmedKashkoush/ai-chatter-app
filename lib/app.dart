import 'package:ai_chatter/config/routes/router.dart';
import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/config/themes/themes.dart';
import 'package:ai_chatter/core/utils/constants.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'config/locales/locale_settings.dart';

class AiChatterApp extends StatelessWidget {
  const AiChatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BetterFeedback(
      theme: FeedbackThemeData(
        background: Colors.grey,
        feedbackSheetColor: Colors.grey[50]!,
        drawColors: [
          Colors.red,
          Colors.green,
          Colors.blue,
          Colors.yellow,
        ],
      ),
      localizationsDelegates: context.localizationDelegates,
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: context.read<ThemeCubit>().themeMode,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: LocaleSettings.useSystemLocale
              ? context.deviceLocale
              : context.locale,
        );
      }),
    );
  }
}
