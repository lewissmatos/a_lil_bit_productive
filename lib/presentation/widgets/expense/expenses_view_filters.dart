import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:a_lil_bit_productive/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../shared/custom_filled_textfield.dart';

class ExpensesViewFilters extends ConsumerStatefulWidget {
  final Function({ExpensesFilter filter}) refetchExpenses;

  const ExpensesViewFilters({super.key, required this.refetchExpenses});

  @override
  ExpensesViewFiltersState createState() => ExpensesViewFiltersState();
}

class ExpensesViewFiltersState extends ConsumerState<ExpensesViewFilters> {
  late ExpensesFilter filterOptions = ExpensesFilter();
  late TextEditingController amountFromController;
  late TextEditingController amountToController;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();

    filterOptions = filterOptions.copyWith(
      category: ref.read(expensesFilterProvider).category,
      dateFrom: ref.read(expensesFilterProvider).dateFrom,
      dateTo: ref.read(expensesFilterProvider).dateTo,
      method: ref.read(expensesFilterProvider).method,
      title: ref.read(expensesFilterProvider).title,
      amountFrom: ref.read(expensesFilterProvider).amountFrom,
      amountTo: ref.read(expensesFilterProvider).amountTo,
    );
    amountFromController = TextEditingController(
        text: filterOptions.amountFrom != null
            ? filterOptions.amountFrom.toString()
            : '');

    amountToController = TextEditingController(
        text: filterOptions.amountTo != null
            ? filterOptions.amountTo.toString()
            : '');

    titleController = TextEditingController(text: filterOptions.title);
  }

  void updateFilters(ExpensesFilter filter) {
    setState(() {
      filterOptions.copyWith(
        category: filter.category,
        dateFrom: filter.dateFrom,
        dateTo: filter.dateTo,
        method: filter.method,
        title: filter.title,
        amountFrom: filter.amountFrom,
        amountTo: filter.amountTo,
      );
    });
  }

  void onOpeDateFromDatePicker() async {
    final selectedDate = await showDatePicker(
      helpText: 'Select date from',
      context: context,
      initialDate: filterOptions.dateFrom ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;
    filterOptions = filterOptions.copyWith(
      dateFrom: DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 0, 0),
    );

    updateFilters(filterOptions);
  }

  void onOpeDateToDatePicker() async {
    final selectedDate = await showDatePicker(
      helpText: 'Select date to',
      context: context,
      initialDate: filterOptions.dateTo ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;
    filterOptions = filterOptions.copyWith(
      dateTo: DateTime(
          selectedDate.year, selectedDate.month, selectedDate.day, 23, 59, 59),
    );

    updateFilters(filterOptions);
  }

  void closeEndDrawer() {
    Scaffold.of(context).closeEndDrawer();
  }

  Future<void> saveChanges() async {
    await widget.refetchExpenses(filter: filterOptions);
    ref.read(expensesFilterProvider.notifier).state = filterOptions;

    closeEndDrawer();
  }

  Future<void> resetFilters() async {
    filterOptions = ExpensesFilter();
    amountFromController.clear();
    amountToController.clear();
    updateFilters(filterOptions);
    await widget.refetchExpenses(filter: filterOptions);
    ref.read(expensesFilterProvider.notifier).state = ExpensesFilter();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (DragStartDetails details) {
        if (details.localPosition.dx < MediaQuery.of(context).size.width / 2) {
          closeEndDrawer();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        color: Theme.of(context).scaffoldBackgroundColor, // updated here
        child: ListView(
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Filter Expenses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Scaffold.of(context).closeEndDrawer();
                  },
                  icon: const Icon(Icons.close, size: 20),
                )
              ],
            ),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: onOpeDateFromDatePicker,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  'From: ${filterOptions.dateFrom != null ? DateFormat('yyyy-MM-dd').format(filterOptions.dateFrom!) : 'yyyy-MM-dd'}',
                ),
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: ElevatedButton.icon(
                onPressed: onOpeDateToDatePicker,
                icon: const Icon(Icons.calendar_month_outlined),
                label: Text(
                  'To: ${filterOptions.dateTo != null ? DateFormat('yyyy-MM-dd').format(filterOptions.dateTo!) : 'yyyy-MM-dd'}',
                ),
                style: ElevatedButton.styleFrom(
                  alignment: Alignment.centerLeft,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(
                height: 16,
                child: Text(
                  "Category",
                  style: TextStyle(fontSize: 12),
                )),
            Wrap(
              spacing: 5,
              alignment: WrapAlignment.start,
              children: [
                ...ExpenseCategoryEnum.values.map(
                  (category) {
                    final accentColor = ExpenseCategoryHelper
                        .expenseDecorators[category.name]!.color;
                    return FilterChip(
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      backgroundColor: accentColor.withOpacity(0.3),
                      onSelected: (selected) {
                        if (selected) {
                          filterOptions =
                              filterOptions.copyWith(category: category);
                          updateFilters(filterOptions);
                        }
                      },
                      selectedColor: accentColor.withOpacity(0.7),
                      selected: category.name == filterOptions.category?.name,
                      label: Text(category.name),
                      labelStyle: const TextStyle(fontSize: 12),
                    );
                  },
                ),
                FilterChip(
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  backgroundColor: Colors.black.withOpacity(0.3),
                  onSelected: (selected) {
                    if (selected) {
                      filterOptions.category = null;
                      updateFilters(filterOptions);
                    }
                  },
                  selectedColor: Colors.black.withOpacity(0.7),
                  selected: filterOptions.category == null,
                  label: const Text('all'),
                  labelStyle: const TextStyle(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
                height: 16,
                child: Text(
                  "Method",
                  style: TextStyle(fontSize: 12),
                )),
            Wrap(
              spacing: 5,
              alignment: WrapAlignment.start,
              children: [
                ...ExpenseMethodEnum.values.map(
                  (method) {
                    final accentColor = ExpenseMethodHelper
                        .expenseDecorators[method.name]!.color;
                    return FilterChip(
                      labelPadding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      backgroundColor: accentColor.withOpacity(0.3),
                      onSelected: (selected) {
                        if (selected) {
                          filterOptions =
                              filterOptions.copyWith(method: method);
                          updateFilters(filterOptions);
                        }
                      },
                      selectedColor: accentColor.withOpacity(0.7),
                      selected: method.name == filterOptions.method?.name,
                      label: Text(method.name),
                      labelStyle: const TextStyle(fontSize: 12),
                    );
                  },
                ),
                FilterChip(
                  labelPadding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  backgroundColor: Colors.black.withOpacity(0.3),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        var newFilter = filterOptions;

                        newFilter.method = null;

                        updateFilters(newFilter);
                      });
                    }
                  },
                  selectedColor: Colors.black.withOpacity(0.7),
                  selected: filterOptions.method == null,
                  label: const Text('all'),
                  labelStyle: const TextStyle(fontSize: 12),
                )
              ],
            ),
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: TextField(
                    controller: amountFromController,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ), // display numeric keyboard with decimal
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*')), // allow only double
                    ],
                    onChanged: (value) {
                      filterOptions = filterOptions.copyWith(
                        amountFrom: double.tryParse(value) ?? 0,
                      );
                      updateFilters(filterOptions);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
                const SizedBox(
                    child: Text('-', style: TextStyle(fontSize: 30))),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.30,
                  child: TextField(
                    controller: amountToController,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ), // display numeric keyboard with decimal
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*')), // allow only double
                    ],
                    onChanged: (value) {
                      filterOptions = filterOptions.copyWith(
                        amountTo: double.tryParse(value) ?? 0,
                      );
                      updateFilters(filterOptions);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      hintText: '0.00',
                      hintStyle: TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ],
            ),
            CustomFilledTextField(
              controller: titleController,
              hintText: 'title',
              onChanged: (value) {
                filterOptions = filterOptions.copyWith(
                  title: value,
                );
                updateFilters(filterOptions);
              },
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 2,
              alignment: WrapAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: TextButton.icon(
                    onPressed: () async {
                      await resetFilters();
                      closeEndDrawer();
                    },
                    label: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.red),
                    ),
                    icon:
                        const Icon(Icons.clear_all_outlined, color: Colors.red),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
                SizedBox(
                  child: ElevatedButton.icon(
                    onPressed: filterOptions == ref.read(expensesFilterProvider)
                        ? null
                        : () async {
                            await saveChanges();
                          },
                    label: const Text('Apply filters'),
                    icon: const Icon(Icons.save_outlined),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
