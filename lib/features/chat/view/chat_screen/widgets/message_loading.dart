import 'package:ai_chatter/core/extensions/space_extension.dart';
import 'package:ai_chatter/core/extensions/theme_extension.dart';
import 'package:ai_chatter/core/utils/images.dart';
import 'package:flutter/material.dart';

class MessageLoading extends StatelessWidget {
  const MessageLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(
          Images.appLogo,
          width: 40,
        ),
        10.w,
        ...List.generate(
          3,
          (index) => _LoadingBar(
            delay: Duration(milliseconds: (index * 300)),
          ),
        ),
      ],
    );
  }
}

class _LoadingBar extends StatefulWidget {
  final Duration delay;
  const _LoadingBar({
    this.delay = const Duration(milliseconds: 300),
  });

  @override
  State<_LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<_LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.1, end: 0.4).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    Future.delayed(widget.delay, () {
      _controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: CircleAvatar(
          radius: 5,
          backgroundColor: context.colorScheme.onBackground,
        ),
      ),
    );
  }
}
