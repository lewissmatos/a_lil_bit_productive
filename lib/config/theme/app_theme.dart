import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;
  final Color colorSchemeSeed;
  AppTheme({this.isDarkMode = false, this.colorSchemeSeed = Colors.blue});

  ThemeData getTheme() => ThemeData(
      colorSchemeSeed: colorSchemeSeed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light);
}
