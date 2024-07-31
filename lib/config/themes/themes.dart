import 'package:ai_chatter/core/utils/colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static final ThemeData light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
  );

  static final ThemeData dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
  );
}
