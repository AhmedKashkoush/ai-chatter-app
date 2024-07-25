import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

extension PopUpExtension on BuildContext {
  Future<T?> showConfirmDialog<T>({
    required String message,
    List<Widget> actions = const [],
  }) {
    return showAdaptiveDialog<T>(
        context: this,
        builder: (context) => AlertDialog(
              title: Text(message),
              actions: actions,
            ));
  }

  void showSnackBar({required String message, IconData? icon}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        backgroundColor: colorScheme.onBackground,
        content: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                color: colorScheme.background,
              ),
            10.w,
            Text(message),
          ],
        ),
      ),
    );
  }
}
