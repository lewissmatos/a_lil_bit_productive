import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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

  @override
  void initState() {
    super.initState();
    expensesByCategoryChartData = aggregateExpensesByCategory(widget.expenses);
    expensesByMethodChartData = aggregateExpensesByMethod(widget.expenses);
  }

  @override
  void didUpdateWidget(covariant ExpensesCharts oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expenses != oldWidget.expenses) {
      expensesByCategoryChartData =
          aggregateExpensesByCategory(widget.expenses);
      expensesByMethodChartData = aggregateExpensesByMethod(widget.expenses);
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
            category: entry.key))
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
            method: entry.key,
            category: ExpenseCategoryEnum.Others))
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
            FadeInRight(
              child: SfCircularChart(
                title: const ChartTitle(
                  text: 'Expenses by Category',
                  alignment: ChartAlignment.center,
                  textStyle: TextStyle(fontSize: 10),
                ),
                margin: const EdgeInsets.all(0),
                series: <CircularSeries>[
                  DoughnutSeries<Expense?, String>(
                    dataSource: expensesByCategoryChartData,
                    xValueMapper: (Expense? data, _) => data?.category.name,
                    yValueMapper: (Expense? data, _) => data?.amount,
                    pointColorMapper: (datum, index) =>
                        ExpenseCategoryHelper.getExpenseCategory(
                                datum!.category)
                            .color
                            .withOpacity(0.8),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    animationDelay: 0.5,
                  ),
                ],
              ),
            ),
            FadeInRight(
              child: SfCircularChart(
                title: const ChartTitle(
                  alignment: ChartAlignment.center,
                  text: 'Expenses by Payment Method',
                  textStyle: TextStyle(fontSize: 10),
                ),
                margin: const EdgeInsets.all(0),
                series: <CircularSeries>[
                  PieSeries<Expense?, String>(
                    dataSource: expensesByMethodChartData,
                    xValueMapper: (Expense? data, _) => data?.method.name,
                    yValueMapper: (Expense? data, _) => data?.amount,
                    pointColorMapper: (datum, index) =>
                        ExpenseMethodHelper.getExpenseMethod(datum!.method)
                            .color
                            .withOpacity(0.8),
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    animationDelay: 0.5,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
