import 'package:ai_chatter/core/utils/constants.dart';
import 'package:ai_chatter/core/utils/images.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool isHero;
  const AppLogo({
    super.key,
    this.size = 200,
    this.isHero = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHero
        ? Hero(
            tag: AppConstants.logoTag,
            child: Image.asset(
              Images.appLogo,
              width: size,
              height: size,
            ))
        : Image.asset(
            Images.appLogo,
            width: size,
            height: size,
          );
  }
}
