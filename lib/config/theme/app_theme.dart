import 'package:flutter/material.dart';

class AppTheme {
  final bool isDarkMode;

  AppTheme({this.isDarkMode = false});

  ThemeData getTheme() => ThemeData(
      colorSchemeSeed: Colors.blue,
      brightness: isDarkMode ? Brightness.dark : Brightness.light);
}
