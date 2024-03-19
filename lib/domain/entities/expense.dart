import 'package:isar/isar.dart';

part 'expense.g.dart';

// ignore: constant_identifier_names
enum ExpenseMethodEnum { Cash, Credit, Loan }

enum ExpenseCategoryEnum {
  Supermarket,
  Transport,
  Shopping,
  Hanging,
  Services,
  Others,
}

@collection
class Expense {
  Id id = Isar.autoIncrement;
  late double amount;
  late String title;
  late DateTime? date;

  @enumerated
  late ExpenseMethodEnum method;

  @enumerated
  late ExpenseCategoryEnum category;

  Expense({
    required this.title,
    required this.amount,
    required this.method,
    this.category = ExpenseCategoryEnum.Others,
    this.date,
  });

  Expense copyWith({
    String? title,
    double? amount,
    ExpenseMethodEnum? method,
    ExpenseCategoryEnum? category,
    DateTime? date,
  }) {
    return Expense(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
}
