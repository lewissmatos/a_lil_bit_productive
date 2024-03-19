import 'package:a_lil_bit_productive/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

class ExpensesView extends ConsumerStatefulWidget {
  const ExpensesView({super.key});

  @override
  ExpensesViewState createState() => ExpensesViewState();
}

class ExpensesViewState extends ConsumerState<ExpensesView> {
  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() async {
    final expenseNotifier = ref.read(expenseNotifierProvider.notifier);

    await expenseNotifier.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    List<Expense?> expenses = ref.watch(expenseNotifierProvider);
    return Scaffold(
      body: Center(
          child: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            expandedHeight: 400,
            collapsedHeight: 200,
            flexibleSpace:
                expenses.isNotEmpty ? ExpensesCharts(expenses: expenses) : null,
            forceMaterialTransparency: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_alt_outlined),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10),
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
