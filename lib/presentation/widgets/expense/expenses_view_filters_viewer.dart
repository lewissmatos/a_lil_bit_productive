import 'package:a_lil_bit_productive/domain/entities/expense_filter.dart';
import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesViewFiltersViewer extends StatefulWidget {
  final ExpensesFilter expensesFilter;
  const ExpensesViewFiltersViewer({super.key, required this.expensesFilter});

  @override
  State<ExpensesViewFiltersViewer> createState() =>
      _ExpensesViewFiltersViewerState();
}

class _ExpensesViewFiltersViewerState extends State<ExpensesViewFiltersViewer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Filters:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                if (widget.expensesFilter.dateFrom != null ||
                    widget.expensesFilter.dateTo != null)
                  Chip(
                    label: Text(
                        '${widget.expensesFilter.dateFrom != null ? DateFormat.yMMMd().format(widget.expensesFilter.dateFrom!) : ''}${widget.expensesFilter.dateTo != null ? ' - ${DateFormat.yMMMd().format(widget.expensesFilter.dateTo!)}' : ''}'),
                  ),
                const SizedBox(width: 10), // Add a gap of 10 pixels

                if (widget.expensesFilter.amountFrom != null ||
                    widget.expensesFilter.amountTo != null)
                  Chip(
                    label: Text(
                        '\$${widget.expensesFilter.amountFrom != null ? widget.expensesFilter.amountFrom!.toStringAsFixed(2) : ''}${widget.expensesFilter.amountTo != null ? ' - \$${widget.expensesFilter.amountTo?.toStringAsFixed(2)}' : ''}'),
                  ),
                const SizedBox(width: 10), // Add a gap of 10 pixels
                if (widget.expensesFilter.category != null)
                  Chip(
                    color: MaterialStateProperty.all(
                      ExpenseCategoryHelper.getExpenseCategory(
                              widget.expensesFilter.category!)
                          .color
                          .withOpacity(0.7),
                    ),
                    label: Text(widget.expensesFilter.category!.name),
                  ),
                const SizedBox(width: 10), // Add a gap of 10 pixels
                if (widget.expensesFilter.method != null)
                  Chip(
                    color: MaterialStateProperty.all(
                      ExpenseMethodHelper.getExpenseMethod(
                              widget.expensesFilter.method!)
                          .color
                          .withOpacity(0.7),
                    ),
                    label: Text(widget.expensesFilter.method!.name),
                  ),
                const SizedBox(width: 10), // Add a gap of 10 pixels
                if (widget.expensesFilter.title != null)
                  Chip(
                    label: Text(widget.expensesFilter.title!),
                  ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
