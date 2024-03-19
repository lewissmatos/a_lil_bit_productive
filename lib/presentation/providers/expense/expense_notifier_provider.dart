import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/domain/repository/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final expenseNotifierProvider =
    StateNotifierProvider<ExpenseNotifier, List<Expense?>>(
  (ref) {
    final expenseRepoProvider = ref.read(expenseRepositoryImplProvider);
    return ExpenseNotifier(
      expenseRepository: expenseRepoProvider,
    );
  },
);

class ExpenseNotifier extends StateNotifier<List<Expense?>> {
  int currentPage = 0;
  bool isFetching = false;

  final ExpenseRepository expenseRepository;
  ExpenseNotifier({
    required this.expenseRepository,
  }) : super([]);

  Future<List<Expense?>> getExpenses({
    DateTime? dateFrom,
    DateTime? dateTo,
    ExpenseCategoryEnum? category,
    ExpenseMethodEnum? type,
    String? title,
    double? value,
  }) async {
    isFetching = true;
    final expenses = await expenseRepository.getExpenses(
      dateFrom: dateFrom,
      dateTo: dateTo,
      category: category,
      type: type,
      title: title,
      value: value,
    );
    state = expenses;
    isFetching = false;
    return expenses;
  }

  Future<Expense?> addExpense({required Expense expense}) async {
    final newExpense = await expenseRepository.addExpense(expense: expense);
    state = [newExpense, ...state];
    return newExpense;
  }

  Future<void> updateExpense(
      {required Expense expense, required int expenseId}) async {
    final newExpense = await expenseRepository.updateExpense(
      expense: expense,
      id: expenseId,
    );

    final index = state.indexWhere((e) => e!.id == expenseId);

    state = [
      ...state.sublist(0, index),
      newExpense ?? expense,
      ...state.sublist(index + 1),
    ];
  }

  Future<void> deleteExpense({required Expense expense}) async {
    await expenseRepository.deleteExpense(id: expense.id);
    state = state.where((e) => e!.id != expense.id).toList();
  }
}
