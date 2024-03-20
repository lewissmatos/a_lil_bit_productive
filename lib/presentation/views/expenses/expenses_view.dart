import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:a_lil_bit_productive/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

class ExpensesView extends ConsumerStatefulWidget {
  const ExpensesView({super.key});

  @override
  ExpensesViewState createState() => ExpensesViewState();
}

class ExpensesViewState extends ConsumerState<ExpensesView> {
  late ExpensesFilter expensesFilter = ExpensesFilter();
  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses({ExpensesFilter? filter}) async {
    final expenseNotifier = ref.read(expenseNotifierProvider.notifier);
    await expenseNotifier.getExpenses(filter: filter);
    setState(() {
      expensesFilter = filter ?? ExpensesFilter();
    });
  }

  Future<void> onGetTotalExpenses() async {
    ref.read(totalExpensesNotifierProvider.notifier).state = await ref
        .read(expenseNotifierProvider.notifier)
        .getTotalExpenses(filter: expensesFilter);
  }

  @override
  Widget build(BuildContext context) {
    List<Expense?> expenses = ref.watch(expenseNotifierProvider);
    double totalExpenses = ref.watch(totalExpensesNotifierProvider);
    // Read the expensesNotifierProvider so that i can refetch the total expenses
    ref.listen(
      expenseNotifierProvider,
      (List<Expense?>? prevExpenses, newExpenses) async {
        await onGetTotalExpenses();
      },
    );
    return Scaffold(
      endDrawer: ExpensesViewFilters(
        refetchExpenses: fetchExpenses,
      ),
      body: Center(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 400,
            collapsedHeight: 270,
            flexibleSpace: expenses.isNotEmpty
                ? ExpensesCharts(
                    expenses: expenses,
                  )
                : const Center(
                    child: Text(
                    'No expenses',
                    style: TextStyle(fontSize: 40),
                  )),
            forceMaterialTransparency: true,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  icon: const Icon(Icons.filter_alt_outlined),
                ),
              ),
            ],
          ),
          if (expensesFilter != ExpensesFilter())
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              if (expensesFilter.dateFrom != null ||
                                  expensesFilter.dateTo != null)
                                Chip(
                                  label: Text(
                                      '${expensesFilter.dateFrom != null ? DateFormat.yMMMd().format(expensesFilter.dateFrom!) : ''}${expensesFilter.dateTo != null ? ' - ${DateFormat.yMMMd().format(expensesFilter.dateTo!)}' : ''}'),
                                ),
                              const SizedBox(
                                  width: 10), // Add a gap of 10 pixels

                              if (expensesFilter.amountFrom != null ||
                                  expensesFilter.amountTo != null)
                                Chip(
                                  label: Text(
                                      '\$${expensesFilter.amountFrom != null ? expensesFilter.amountFrom!.toStringAsFixed(2) : ''}${expensesFilter.amountTo != null ? ' - \$${expensesFilter.amountTo?.toStringAsFixed(2)}' : ''}'),
                                ),
                              const SizedBox(
                                  width: 10), // Add a gap of 10 pixels
                              if (expensesFilter.category != null)
                                Chip(
                                  color: MaterialStateProperty.all(
                                      ExpenseCategoryHelper.getExpenseCategory(
                                              expensesFilter.category!)
                                          .color
                                          .withOpacity(0.7)),
                                  label: Text(expensesFilter.category!.name),
                                ),
                              const SizedBox(
                                  width: 10), // Add a gap of 10 pixels
                              if (expensesFilter.method != null)
                                Chip(
                                  color: MaterialStateProperty.all(
                                      ExpenseMethodHelper.getExpenseMethod(
                                              expensesFilter.method!)
                                          .color
                                          .withOpacity(0.7)),
                                  label: Text(expensesFilter.method!.name),
                                ),
                              const SizedBox(
                                  width: 10), // Add a gap of 10 pixels
                              if (expensesFilter.title != null)
                                Chip(
                                  label: Text(expensesFilter.title!),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(
                  'Total: ~\$${totalExpenses.toStringAsFixed(2)} (${expenses.length})',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 80),
                child: ExpensesListView(expenses: expenses),
              )
            ]),
          ),
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/base/2/add-expense');
        },
        label: const Text('Add Expense'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
