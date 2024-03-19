import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';
import '../widgets.dart';

class ExpensesListView extends StatefulWidget {
  final List<Expense?> expenses;
  const ExpensesListView({super.key, required this.expenses});

  @override
  State<ExpensesListView> createState() => _ExpensesListViewState();
}

class _ExpensesListViewState extends State<ExpensesListView> {
  @override
  Widget build(BuildContext context) {
    return FadeInUp(
        child: Column(children: [
      ...widget.expenses.map((
        expense,
      ) {
        final expenseCategoryDecorator =
            ExpenseCategoryHelper.getExpenseCategory(expense!.category);

        final index = widget.expenses.indexOf(expense);
        Widget listItem = ExpenseListItem(
          expense: expense,
          expenseCategoryDecorator: expenseCategoryDecorator,
        );

        bool isDifferentDate(DateTime date1, DateTime date2) {
          return date1.month != date2.month || date1.year != date2.year;
        }

        if (index == 0 ||
            isDifferentDate(
              widget.expenses[index - 1]!.date!,
              expense.date!,
            )) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('MMMM yyyy').format(expense.date!),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              listItem,
            ],
          );
        } else {
          return listItem;
        }
      }).toList(),
    ]));
  }
}
