import '../entities/entities.dart';

abstract class ExpenseDataSource {
  Future<List<Expense?>> getExpenses({ExpensesFilter? filter});
  Future<Expense?> getExpense({required int id});
  Future<Expense?> addExpense({required Expense expense});
  Future<void> deleteExpense({required int id});
  Future<Expense?> updateExpense({
    required Expense expense,
    required int id,
  });
}
