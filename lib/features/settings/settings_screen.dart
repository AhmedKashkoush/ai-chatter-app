import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: Column(
        children: [
          PopupMenuButton<ThemeMode>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            itemBuilder: (context) => _options(context),
            onSelected: (theme) => context.read<ThemeCubit>().themeMode = theme,
            child: ListTile(
              leading: Icon(
                _getBrightnessIcon(context),
              ),
              title: const Text(AppStrings.theme),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getBrightnessIcon(BuildContext context) {
    bool isDark = context.colorScheme.brightness == Brightness.dark;
    return !isDark ? CupertinoIcons.brightness : CupertinoIcons.moon;
  }

  List<PopupMenuEntry<ThemeMode>> _options(BuildContext context) {
    return [
      PopupMenuItem<ThemeMode>(
        value: ThemeMode.system,
        child: ListTile(
          leading: Icon(_getBrightnessIcon(context)),
          title: const Text(AppStrings.system),
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<ThemeMode>(
        value: ThemeMode.light,
        child: ListTile(
          leading: Icon(CupertinoIcons.moon),
          title: Text(AppStrings.light),
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<ThemeMode>(
        value: ThemeMode.dark,
        child: ListTile(
          leading: Icon(CupertinoIcons.brightness),
          title: Text(AppStrings.dark),
        ),
      ),
    ];
  }
}
