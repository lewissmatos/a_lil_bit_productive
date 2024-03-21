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
                  icon: Icon(expensesFilter == ExpensesFilter()
                      ? Icons.filter_alt_outlined
                      : Icons.filter_alt),
                ),
              ),
            ],
          ),
          if (expensesFilter != ExpensesFilter())
            SliverToBoxAdapter(
                child:
                    ExpensesViewFiltersViewer(expensesFilter: expensesFilter)),
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
