import 'package:ai_chatter/core/keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPreferences prefs;
  ThemeCubit(this.prefs) : super(ThemeMode.system);

  ThemeMode get themeMode {
    String mode = prefs.getString(AppKeys.theme) ?? 'system';
    ThemeMode themeMode = ThemeMode.values.byName(mode);
    return themeMode;
  }

  set themeMode(ThemeMode mode) {
    prefs.setString(AppKeys.theme, mode.name).then((_) => emit(mode));
  }
}
