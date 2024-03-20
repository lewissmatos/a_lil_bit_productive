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
  Future<List<Expense?>> getExpenses({ExpensesFilter? filter}) async {
    final isar = await isarDb;

    late List<Expense?> expenses;

    print(
        '${filter?.amountFrom} ${filter?.amountTo} + ${filter?.dateFrom} + ${filter?.dateTo} +  ${filter?.category} ${filter?.method}, ${filter?.title}');

    expenses = await isar.txn(() async {
      return await isar.expenses
          .filter()
          .optional(
              filter?.title != null, (q) => q.titleContains(filter!.title!))
          .optional(filter?.amountFrom != null && filter!.amountTo != null,
              (q) => q.amountBetween(filter!.amountFrom!, filter.amountTo!))
          .optional(
            filter?.dateFrom != null && filter?.dateTo != null,
            (q) => q.dateBetween(filter!.dateFrom!, filter.dateTo!),
          )
          .optional(
            filter?.category != null,
            (q) => q.categoryEqualTo(filter!.category!),
          )
          .optional(
            filter?.method != null,
            (q) => q.methodEqualTo(filter!.method!),
          )
          .sortByDateDesc()
          .findAll();
    });

    return expenses;
  }
}
