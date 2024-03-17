import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class Category {
  final Color color;
  final String emoji;

  Category({required this.color, required this.emoji});
}

typedef CategoryMap = Map<CategoriesEnum, Category>;

class NoteCategoryHelper {
  static final List<String> emojis = [
    '👨‍💻',
    '📚',
    '👤',
    '🛠️',
  ];

  static final List<Color> categoryColors = [
    Colors.orange,
    Colors.blue,
    Colors.green,
    Colors.grey[500]!
  ];

  Category getCategory(CategoriesEnum category) {
    final index = category.index;
    final color = categoryColors[index];
    final emoji = emojis[index];
    return Category(color: color, emoji: emoji);
  }
}
