import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static const _darkModeKey = 'darkMode';
  static const _colorSchemeSeedKey = 'colorSchemeSeed';
  static Future<void> setDarkMode(bool enabled) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_darkModeKey, enabled);
  }

  static Future<bool> getDarkMode() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_darkModeKey) ?? false;
  }

  static Future<void> setColorSchemeSeed(Color color) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setInt(_colorSchemeSeedKey, color.value);
  }

  static Future<Color> getColorSchemeSeed() async {
    final preferences = await SharedPreferences.getInstance();
    return Color(preferences.getInt(_colorSchemeSeedKey) ?? Colors.blue.value);
  }
}
