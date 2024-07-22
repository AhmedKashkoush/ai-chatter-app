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

  void showSnackBar({required String message}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
        content: Text(message),
      ),
    );
  }
}
