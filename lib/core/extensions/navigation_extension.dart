import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  void pushNamed(String route) => Navigator.of(this).pushNamed(route);

  void pushReplacementNamed(String route) =>
      Navigator.of(this).pushReplacementNamed(route);
}
