import 'package:flutter/material.dart';

class ColorHelper {
  static Color? getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return null;
    }
    return Color(int.parse('0xFF$hexColor'));
  }

  static String getHexFromColor(Color color) {
    return color.value.toRadixString(16).substring(2);
  }

  static String getHexFromColorSwatch(ColorSwatch<dynamic> color) {
    return color.toString().split('(0x')[1].split(')')[0].substring(2);
  }

  static ColorSwatch getColorSwatchFormColor(Color color) {
    return ColorSwatch(color.value, {
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1),
    });
  }
}
