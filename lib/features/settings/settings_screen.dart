import 'package:ai_chatter/config/locales/locale_settings.dart';
import 'package:ai_chatter/config/locales/locales.dart';
import 'package:ai_chatter/config/other/chat_settings.dart';
import 'package:ai_chatter/config/routes/routes.dart';
import 'package:ai_chatter/config/themes/theme_cubit.dart';
import 'package:ai_chatter/core/extensions/navigation_extension.dart';
import 'package:ai_chatter/core/extensions/popup_extension.dart';
import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/core/utils/strings.dart';
import 'package:ai_chatter/core/utils/utils.dart';
import 'package:ai_chatter/features/chat/view/chat_screen/logic/chat_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final ValueNotifier<bool> _suggestionsEnabled, _useSystemLocale;

  @override
  void initState() {
    _suggestionsEnabled = ValueNotifier<bool>(
      ChatSettings.suggestionsEnabled,
    );
    _useSystemLocale = ValueNotifier<bool>(
      LocaleSettings.useSystemLocale,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr(AppStrings.settings),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _showThemeDialog(context),
            leading: Icon(
              _getBrightnessIcon(context),
            ),
            title: Text(
              context.tr(AppStrings.theme),
            ),
            subtitle:
                BlocBuilder<ThemeCubit, ThemeMode>(builder: (context, state) {
              return Text(
                context.tr(state.name),
              );
            }),
          ),
          ListTile(
            onTap: () => _showLocaleDialog(context),
            leading: const Icon(
              Icons.language,
            ),
            title: Text(context.tr(AppStrings.languages)),
            subtitle: ValueListenableBuilder(
                valueListenable: _useSystemLocale,
                builder: (context, value, _) {
                  return Text(
                    value
                        ? context.tr(AppStrings.system)
                        : AppStrings.langs[context.locale.languageCode]!,
                  );
                }),
          ),
          const Divider(),
          ValueListenableBuilder(
            valueListenable: _suggestionsEnabled,
            builder: (_, value, __) => SwitchListTile.adaptive(
              title: Text(
                context.tr(AppStrings.suggestions),
              ),
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
                title: Text(
                  context.tr(AppStrings.clearChatHistory),
                ),
                trailing: const Icon(Icons.clear),
              );
            },
          ),
          const Divider(),
          ListTile(
            onTap: () => _sendFeedback(context),
            leading: const Icon(Icons.flag_outlined),
            title: Text(
              context.tr(AppStrings.reportAnIssue),
            ),
          ),
          ListTile(
            onTap: _goToAbout,
            leading: const Icon(Icons.info_outline),
            title: Text(
              context.tr(AppStrings.aboutTheApp),
            ),
          ),
          const Divider(),
          12.h,
          Text(
            context.tr(
              AppStrings.version,
              namedArgs: {
                AppStrings.version: AppConstants.appVersion,
              },
            ),
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.h,
        ],
      ),
    );
  }

  void _goToAbout() {
    context.pushNamed(AppRoutes.about);
  }

  void _sendFeedback(BuildContext context) {
    BetterFeedback.of(context).show(AppUtils.sendUserFeedback);
  }

  void _clearCache(BuildContext context) {
    context.showConfirmDialog(
        message: context.tr(AppStrings.confirmToClearHistory),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              context.tr(AppStrings.no),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(
              context.tr(AppStrings.yes),
              style: const TextStyle(
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

  List<RadioListTile> _themeOptions(
      BuildContext context, ValueNotifier<ThemeMode> notifier) {
    return [
      RadioListTile(
        groupValue: notifier.value,
        value: ThemeMode.system,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: Icon(_getBrightnessIcon(context)),
        title: Text(
          context.tr(AppStrings.system),
        ),
        onChanged: (value) => _changeThemeValue(notifier, value),
      ),
      RadioListTile(
        groupValue: notifier.value,
        value: ThemeMode.light,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: const Icon(CupertinoIcons.brightness),
        title: Text(
          context.tr(AppStrings.light),
        ),
        onChanged: (value) => _changeThemeValue(notifier, value),
      ),
      RadioListTile(
        groupValue: notifier.value,
        value: ThemeMode.dark,
        controlAffinity: ListTileControlAffinity.trailing,
        secondary: const Icon(CupertinoIcons.moon),
        title: Text(
          context.tr(AppStrings.dark),
        ),
        onChanged: (value) => _changeThemeValue(notifier, value),
      ),
    ];
  }

  List<RadioListTile> _localeOptions(
      BuildContext context, ValueNotifier<String> notifier) {
    return [
      RadioListTile(
        groupValue: notifier.value,
        value: 'system',
        controlAffinity: ListTileControlAffinity.trailing,
        // secondary: Icon(_getBrightnessIcon(context)),
        title: Text(
          context.tr(AppStrings.system),
        ),
        subtitle: Text(
          AppStrings.langs[context.deviceLocale.languageCode]!,
        ),
        onChanged: (value) => _changeLocaleValue(notifier, value),
      ),
      ...AppLocales.supportedLocales.map(
        (locale) {
          return RadioListTile(
            groupValue: notifier.value,
            value: locale.languageCode,
            controlAffinity: ListTileControlAffinity.trailing,
            // secondary: Icon(_getBrightnessIcon(context)),
            title: Text(AppStrings.langs[locale.languageCode]!),
            onChanged: (value) => _changeLocaleValue(notifier, value),
          );
        },
      ),
    ];
  }

  void _toggleSuggestions(BuildContext context, bool value) async {
    if (!value) {
      context.read<ChatCubit>().clearSuggestions();
    }
    _suggestionsEnabled.value = value;
    await ChatSettings.setSuggestionsEnabled(value);
  }

  void _showThemeDialog(BuildContext context) {
    ValueNotifier<ThemeMode> themeMode = ValueNotifier<ThemeMode>(
      context.read<ThemeCubit>().themeMode,
    );
    context.showDialog<ThemeMode>(
      content: ValueListenableBuilder(
        valueListenable: themeMode,
        builder: (context, value, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: _themeOptions(context, themeMode),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(themeMode.value),
          child: Text(
            context.tr(AppStrings.confirm),
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            context.tr(AppStrings.cancel),
          ),
        ),
      ],
    ).then((theme) {
      if (theme != null) {
        context.read<ThemeCubit>().themeMode = theme;
      }
    });
  }

  void _showLocaleDialog(BuildContext context) {
    ValueNotifier<String> locale = ValueNotifier<String>(
      LocaleSettings.useSystemLocale ? 'system' : context.locale.languageCode,
    );
    context.showDialog<String>(
      content: ValueListenableBuilder(
        valueListenable: locale,
        builder: (context, value, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: _localeOptions(context, locale),
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(locale.value),
          child: Text(
            context.tr(AppStrings.confirm),
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            context.tr(AppStrings.cancel),
          ),
        ),
      ],
    ).then((locale) async {
      if (locale != null) {
        if (locale == 'system') {
          context.resetLocale();
          await LocaleSettings.setUseSystemLocale(true);
          _useSystemLocale.value = true;
          return;
        }
        context.setLocale(Locale(locale));
        await LocaleSettings.setUseSystemLocale(false);
        _useSystemLocale.value = false;
      }
    });
  }

  void _changeThemeValue(ValueNotifier<ThemeMode> notifier, ThemeMode value) {
    notifier.value = value;
  }

  void _changeLocaleValue(ValueNotifier<String> notifier, String value) {
    notifier.value = value;
  }
}
