import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/entities.dart';

// ignore: must_be_immutable
class ExpenseCategorySelector extends StatefulWidget {
  Expense expense;
  final void Function(Expense expense) updateExpense;

  ExpenseCategorySelector({
    super.key,
    required this.expense,
    required this.updateExpense,
  });

  @override
  State<ExpenseCategorySelector> createState() =>
      _ExpenseCategorySelectorState();
}

class _ExpenseCategorySelectorState extends State<ExpenseCategorySelector> {
  @override
  void initState() {
    super.initState();
  }

  void setCategory(ExpenseCategoryEnum category) {
    setState(() {
      widget.updateExpense(widget.expense.copyWith(category: category));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      alignment: WrapAlignment.start,
      children: [
        ...ExpenseCategoryEnum.values.map(
          (category) {
            final accentColor =
                ExpenseCategoryHelper.expenseDecorators[category.name]!.color;
            return FilterChip(
              labelPadding: const EdgeInsets.symmetric(
                horizontal: 3,
              ),
              backgroundColor: accentColor.withOpacity(0.3),
              onSelected: (selected) {
                if (selected) {
                  setCategory(category);
                }
              },
              selectedColor: accentColor.withOpacity(0.7),
              selected: category.name == widget.expense.category.name,
              label: Text(category.name),
              labelStyle: const TextStyle(fontSize: 12),
            );
          },
        )
      ],
    );
  }
}
