import '../entities/entities.dart';

abstract class ExpenseRepository {
  Future<List<Expense?>> getExpenses({
    DateTime? dateFrom,
    DateTime? dateTo,
    ExpenseCategoryEnum? category,
    ExpenseMethodEnum? type,
    String? title,
    double? value,
  });
  Future<Expense?> getExpense({required int id});
  Future<Expense?> addExpense({required Expense expense});
  Future<void> deleteExpense({required int id});
  Future<Expense?> updateExpense({
    required Expense expense,
    required int id,
  });
}
