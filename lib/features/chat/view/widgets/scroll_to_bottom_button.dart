import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:flutter/material.dart';

class ScrollToBottomButton extends StatelessWidget {
  final void Function()? onPressed;
  final ValueNotifier<bool> showScrollButton;
  const ScrollToBottomButton({
    super.key,
    required this.showScrollButton,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: showScrollButton,
      builder: (context, value, child) => AnimatedOpacity(
        opacity: value ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: AnimatedScale(
          scale: value ? 1 : 0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: child,
        ),
      ),
      child: IconButton.filled(
        color: context.colorScheme.primary,
        style: IconButton.styleFrom(
            backgroundColor: context.colorScheme.background),
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_downward),
      ),
    );
  }
}
