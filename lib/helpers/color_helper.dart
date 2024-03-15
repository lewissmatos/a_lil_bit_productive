import 'package:flutter/material.dart';

class ColorHelper {
  static Color getColorFromHex(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.transparent;
    }
    return Color(int.parse('0xFF$hexColor'));
  }

  static String getHexFromColor(Color color) {
    return color.value.toRadixString(16).substring(2);
  }

  static String getHexFromColorSwatch(ColorSwatch<dynamic> color) {
    return color.toString().split('(0x')[1].split(')')[0].substring(2);
  }
}
