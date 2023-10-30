import 'package:flutter/material.dart';

sealed class AppTheme {
  static final themeData = ThemeData(
    canvasColor: Colors.transparent,
    scaffoldBackgroundColor: pageBackground,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
  );

  static Color get primaryColor => themeData.colorScheme.primary;
  static Color get pageBackground => const Color(0xFFEFEFEF);
}
