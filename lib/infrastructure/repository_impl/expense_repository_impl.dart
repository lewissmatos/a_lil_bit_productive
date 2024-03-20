import 'package:a_lil_bit_productive/domain/datasources/expense_datasource.dart';
import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/domain/entities/expense.dart';
import 'package:a_lil_bit_productive/domain/repository/expense_repository.dart';

class ExpenseRepositoryImpl extends ExpenseRepository {
  ExpenseDataSource expenseDataSource;

  ExpenseRepositoryImpl({required this.expenseDataSource});

  @override
  Future<Expense?> addExpense({required Expense expense}) async {
    return await expenseDataSource.addExpense(expense: expense);
  }

  @override
  Future<void> deleteExpense({required int id}) async {
    return await expenseDataSource.deleteExpense(id: id);
  }

  @override
  Future<Expense?> getExpense({required int id}) async {
    return await expenseDataSource.getExpense(id: id);
  }

  @override
  Future<List<Expense?>> getExpenses({ExpensesFilter? filter}) async {
    return await expenseDataSource.getExpenses(filter: filter);
  }

  @override
  Future<Expense?> updateExpense(
      {required Expense expense, required int id}) async {
    return await expenseDataSource.updateExpense(expense: expense, id: id);
  }
}
