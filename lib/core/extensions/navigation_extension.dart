import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  void pushNamed(String route, {dynamic arguments}) =>
      Navigator.of(this).pushNamed(
        route,
        arguments: arguments,
      );

  void pushReplacementNamed(String route, {dynamic arguments}) =>
      Navigator.of(this).pushReplacementNamed(
        route,
        arguments: arguments,
      );
}
