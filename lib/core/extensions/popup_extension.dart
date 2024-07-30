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
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: actions,
      ),
    );
  }

  Future<T?> showDialog<T>({
    required Widget content,
    List<Widget> actions = const [],
  }) {
    return showAdaptiveDialog<T>(
      context: this,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        content: content,
        actions: actions,
      ),
    );
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

  Future<T?> showMessageMenu<T>({
    required List<PopupMenuEntry<T>> items,
    required bool isMe,
  }) {
    final RenderBox renderBox = findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final double start = offset.dx;
    final double bottom = offset.dy;
    final double end = start + renderBox.size.width;
    final double top = bottom + renderBox.size.height;
    return showMenu(
      context: this,
      position: RelativeRect.fromDirectional(
        textDirection: Directionality.of(this),
        start: isMe ? start + renderBox.size.width : start + 40,
        top: top,
        end: end,
        bottom: bottom,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      items: items,
    );
  }
}
