import 'package:flutter/material.dart';

extension NavigationExtension on BuildContext {
  void pop() => Navigator.of(this).pop();

  void pushNamed(String route) => Navigator.of(this).pushNamed(route);

  void pushReplacementNamed(String route) =>
      Navigator.of(this).pushReplacementNamed(route);
}
