import 'package:a_lil_bit_productive/config/preferences/user_preferences.dart';
import 'package:a_lil_bit_productive/config/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme()) {
    loadThemePreferences();
  }

  Future<void> loadThemePreferences() async {
    bool darkMode = await Preferences.getDarkMode();
    Color colorSchemeSeed = await Preferences.getColorSchemeSeed();
    state = AppTheme(isDarkMode: darkMode, colorSchemeSeed: colorSchemeSeed);
  }

  void toggleTheme() async {
    bool newDarkMode = !state.isDarkMode;
    await Preferences.setDarkMode(newDarkMode);
    state = AppTheme(
        isDarkMode: newDarkMode, colorSchemeSeed: state.colorSchemeSeed);
  }

  void setColorSchemeSeed(Color color) async {
    await Preferences.setColorSchemeSeed(color);
    state = AppTheme(isDarkMode: state.isDarkMode, colorSchemeSeed: color);
  }
}
