import 'package:flutter/cupertino.dart';

extension MediaQueryExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  EdgeInsets get screenPadding => mediaQuery.viewInsets;
  double get bottomInsets => screenPadding.bottom;
}
