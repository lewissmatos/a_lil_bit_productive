import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class ExpenseCategoryDecorator {
  final Color color;
  final IconData icon;

  ExpenseCategoryDecorator({required this.color, required this.icon});
}

typedef CategoryMap = Map<ExpenseCategoryEnum, Expense>;

class ExpenseCategoryHelper {
  static final Map<String, ExpenseCategoryDecorator> expenseDecorators = {
    'Supermarket': ExpenseCategoryDecorator(
        color: Colors.amber, icon: Icons.shopping_cart_outlined),
    'Transport': ExpenseCategoryDecorator(
        color: Colors.green, icon: Icons.directions_bus_outlined),
    'Shopping': ExpenseCategoryDecorator(
        color: Colors.blue, icon: Icons.shopping_bag_outlined),
    'Hanging': ExpenseCategoryDecorator(
        color: Colors.pink, icon: Icons.local_bar_outlined),
    'Services': ExpenseCategoryDecorator(
        color: Colors.purple, icon: Icons.settings_suggest_outlined),
    'Others': ExpenseCategoryDecorator(
        color: Colors.grey[500]!, icon: Icons.more_horiz_outlined),
  };

  static ExpenseCategoryDecorator getExpenseCategory(
      ExpenseCategoryEnum category) {
    final color = expenseDecorators[category.name]!.color;
    final icon = expenseDecorators[category.name]!.icon;
    return ExpenseCategoryDecorator(color: color, icon: icon);
  }
}
