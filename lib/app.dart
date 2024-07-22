import 'package:ai_chatter/config/routes/router.dart';
import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/config/themes/themes.dart';
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/features/chat/view/logic/chat_cubit.dart';

import 'package:ai_chatter/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiChatterApp extends StatelessWidget {
  const AiChatterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: locator<ThemeCubit>(),
        ),
        BlocProvider.value(
          value: locator<ChatCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: context.read<ThemeCubit>().themeMode,
          initialRoute: AppRouter.initialRoute,
          onGenerateRoute: AppRouter.onGenerateRoute,
        );
      }),
    );
  }
}
