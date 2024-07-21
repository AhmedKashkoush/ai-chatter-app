import 'package:ai_chatter/core/constants.dart';
import 'package:ai_chatter/core/images.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({
    super.key,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: AppConstants.logoTag,
      child: Image.asset(
        Images.appLogo,
        width: size,
        height: size,
      ),
    );
  }
}
