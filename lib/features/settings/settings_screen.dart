import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/popup_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/keys.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:ai_chatter/locator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ValueNotifier<bool> _suggestionsEnabled = ValueNotifier<bool>(
      locator<SharedPreferences>().getBool(AppKeys.suggestions) ?? true);

  @override
  Widget build(BuildContext context) {
    final ThemeCubit cubit = context.read<ThemeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: ListView(
        children: [
          PopupMenuButton<ThemeMode>(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            itemBuilder: (context) => _options(context),
            onSelected: (theme) => cubit.themeMode = theme,
            child: ListTile(
              leading: Icon(
                _getBrightnessIcon(context),
              ),
              title: const Text(AppStrings.theme),
              subtitle: Text(
                "${cubit.themeMode.name.replaceFirst(
                  cubit.themeMode.name.characters.first,
                  cubit.themeMode.name.characters.first.toUpperCase(),
                )}${ThemeMode.system == cubit.themeMode ? ' (default)' : ''}",
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _suggestionsEnabled,
            builder: (_, value, __) => SwitchListTile.adaptive(
              title: const Text(AppStrings.suggestions),
              onChanged: (value) => _toggleSuggestions(context, value),
              value: value,
            ),
          ),
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return ListTile(
                onTap:
                    state.messages.isEmpty ? null : () => _clearCache(context),
                textColor: Colors.red,
                iconColor: Colors.red,
                enabled: state.messages.isNotEmpty,
                leading: const Icon(Icons.history),
                title: const Text(AppStrings.clearChatHistory),
                trailing: const Icon(Icons.clear),
              );
            },
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    context
        .showConfirmDialog(message: AppStrings.confirmToClearHistory, actions: [
      TextButton(
        onPressed: () => context.pop(),
        child: const Text(AppStrings.no),
      ),
      TextButton(
        onPressed: () => context.pop(true),
        child: const Text(
          AppStrings.yes,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
      ),
    ]).then(
      (confirm) =>
          confirm ? context.read<ChatCubit>().clearChatHistory() : null,
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

  void _toggleSuggestions(BuildContext context, bool value) async {
    if (!value) {
      context.read<ChatCubit>().clearSuggestions();
    }
    _suggestionsEnabled.value = value;
    await locator<SharedPreferences>().setBool(AppKeys.suggestions, value);
  }
}
