import 'package:flutter/material.dart';

class StylingConfig {
  final EdgeInsets contentPadding;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const StylingConfig({
    this.contentPadding = const EdgeInsets.all(16),
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
  });
}
