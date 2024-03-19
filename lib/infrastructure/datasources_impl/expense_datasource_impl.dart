import 'package:a_lil_bit_productive/domain/datasources/expense_datasource.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/entities.dart';

class ExpenseDataSourceImpl extends ExpenseDataSource {
  late Future<Isar> isarDb;

  ExpenseDataSourceImpl() {
    isarDb = openIsarDb();
  }

  Future<Isar> openIsarDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync(
        [
          ReminderSchema,
          NoteSchema,
          ShortStorySchema,
          ExpenseSchema,
        ],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<Expense?> addExpense({required Expense expense}) async {
    final isar = await isarDb;

    expense = expense.copyWith(date: DateTime.now());
    isar.writeTxn(() async {
      final expenseId = await isar.expenses.put(expense);
      expense.id = expenseId;
    });
    return expense;
  }

  @override
  Future<void> deleteExpense({required int id}) async {
    final isar = await isarDb;

    isar.writeTxn(() async {
      await isar.expenses.delete(id);
    });
  }

  @override
  Future<Expense?> getExpense({required int id}) async {
    final isar = await isarDb;

    return isar.expenses.where().idEqualTo(id).findFirst();
  }

  @override
  Future<Expense?> updateExpense(
      {required Expense expense, required int id}) async {
    final isar = await isarDb;

    Expense? expenseToUpdate =
        isar.expenses.where().idEqualTo(id).findFirstSync();

    if (expenseToUpdate == null) return null;

    expenseToUpdate = expenseToUpdate.copyWith(
      amount: expense.amount,
      category: expense.category,
      method: expense.method,
      title: expense.title,
      date: expense.date,
    );

    expenseToUpdate.id = id;

    isar.writeTxn(() async {
      await isar.expenses.put(expenseToUpdate!);
    });

    return expenseToUpdate;
  }

  @override
  Future<List<Expense?>> getExpenses({
    DateTime? dateFrom,
    DateTime? dateTo,
    ExpenseCategoryEnum? category,
    ExpenseMethodEnum? type,
    String? title,
    double? value,
  }) async {
    final isar = await isarDb;

    late List<Expense?> expenses;

    expenses = await isar.txn(() async {
      return await isar.expenses
          .filter()
          .optional(title != null, (q) => q.titleContains(title!))
          .optional(value != null, (q) => q.amountBetween(value!, value))
          .optional(
            dateFrom != null && dateTo != null,
            (q) => q.dateBetween(dateFrom!, dateTo!),
          )
          .optional(
            category != null,
            (q) => q.categoryEqualTo(category!),
          )
          .optional(
            type != null,
            (q) => q.methodEqualTo(type!),
          )
          .sortByDateDesc()
          .findAll();
    });

    return expenses;
  }
}
