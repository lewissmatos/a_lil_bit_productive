import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';

class ExpensesCharts extends StatefulWidget {
  final List<Expense?> expenses;
  const ExpensesCharts({super.key, required this.expenses});

  @override
  State<ExpensesCharts> createState() => _ExpensesChartsState();
}

class _ExpensesChartsState extends State<ExpensesCharts> {
  late List<Expense?> expensesByCategoryChartData;
  late List<Expense?> expensesByMethodChartData;
  late List<Expense?> expensesByMonthChartData;

  @override
  void initState() {
    super.initState();
    expensesByCategoryChartData = aggregateExpensesByCategory(widget.expenses);
    expensesByMethodChartData = aggregateExpensesByMethod(widget.expenses);
    expensesByMonthChartData = aggregateExpensesByMonth(widget.expenses);
  }

  @override
  void didUpdateWidget(covariant ExpensesCharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expenses != oldWidget.expenses) {
      expensesByCategoryChartData =
          aggregateExpensesByCategory(widget.expenses);
      expensesByMethodChartData = aggregateExpensesByMethod(widget.expenses);
      expensesByMonthChartData = aggregateExpensesByMonth(widget.expenses);
    }
  }

  List<Expense> aggregateExpensesByCategory(List<Expense?> expenses) {
    final Map<ExpenseCategoryEnum, double> aggregatedExpenses = {};
    for (final expense in expenses) {
      final category = expense?.category;
      final amount = expense?.amount;
      if (category != null && amount != null) {
        aggregatedExpenses.update(
            category, (existingValue) => existingValue + amount,
            ifAbsent: () => amount);
      }
    }

    return aggregatedExpenses.entries
        .map((entry) => Expense(
              title: entry.key.toString(),
              amount: entry.value,
              method: ExpenseMethodEnum.Cash,
              category: entry.key,
            ))
        .toList();
  }

  List<Expense> aggregateExpensesByMethod(List<Expense?> expenses) {
    final Map<ExpenseMethodEnum, double> aggregatedExpenses = {};
    for (final expense in expenses) {
      final method = expense?.method;
      final amount = expense?.amount;
      if (method != null && amount != null) {
        aggregatedExpenses.update(
            method, (existingValue) => existingValue + amount,
            ifAbsent: () => amount);
      }
    }

    return aggregatedExpenses.entries
        .map((entry) => Expense(
              title: entry.key.toString(),
              amount: entry.value,
              category: ExpenseCategoryEnum.Others,
              method: entry.key,
            ))
        .toList();
  }

  List<Expense> aggregateExpensesByMonth(List<Expense?> expenses) {
    final Map<int, double> aggregatedExpenses = {};
    for (final expense in expenses) {
      final date = expense?.date?.month;
      final amount = expense?.amount;
      if (date != null && amount != null) {
        aggregatedExpenses.update(
            date, (existingValue) => existingValue + amount,
            ifAbsent: () => amount);
      }
    }

    return aggregatedExpenses.entries
        .map((entry) => Expense(
            title: entry.key.toString(),
            amount: entry.value,
            method: ExpenseMethodEnum.Cash,
            category: ExpenseCategoryEnum.Others,
            date: DateTime(DateTime.now().year, entry.key, 1)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      width: 400,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: PageView(
          scrollDirection: Axis.horizontal,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Expenses by Category',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FadeInRight(
                      child: PieChart(
                        PieChartData(
                          sections: expensesByCategoryChartData
                              .map((Expense? expense) {
                            return PieChartSectionData(
                              color: ExpenseCategoryHelper.getExpenseCategory(
                                expense!.category,
                              ).color.withOpacity(0.8),
                              value: expense.amount,
                              title:
                                  '${expense.category.name}\n${expense.amount.toStringAsFixed(0)}',
                              radius: 90,
                              titleStyle: const TextStyle(fontSize: 11),
                              titlePositionPercentageOffset: 0.6,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Expenses by Method',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FadeInRight(
                      child: PieChart(
                        PieChartData(
                          sections:
                              expensesByMethodChartData.map((Expense? expense) {
                            return PieChartSectionData(
                              color: ExpenseMethodHelper.getExpenseMethod(
                                expense!.method,
                              ).color.withOpacity(0.8),
                              value: expense.amount,
                              title:
                                  '${expense.method.name}\n${expense.amount.toStringAsFixed(0)}',
                              radius: 90,
                              titleStyle: const TextStyle(fontSize: 11),
                              titlePositionPercentageOffset: 0.6,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Expenses by Month',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: FadeInRight(
                      child: PieChart(
                        PieChartData(
                          sections:
                              expensesByMonthChartData.map((Expense? expense) {
                            return PieChartSectionData(
                              color: Colors.primaries[expense!.date!.month]
                                  .withOpacity(0.7),
                              value: expense.amount,
                              title:
                                  '${DateFormat.MMM().format(expense.date!)}\n${expense.amount.toStringAsFixed(0)}',
                              radius: 90,
                              titleStyle: const TextStyle(fontSize: 13),
                              titlePositionPercentageOffset: 0.7,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
