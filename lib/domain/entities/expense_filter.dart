import 'package:a_lil_bit_productive/domain/entities/expense.dart';

class ExpensesFilter {
  late DateTime? dateFrom;
  late DateTime? dateTo;
  late ExpenseCategoryEnum? category;
  late ExpenseMethodEnum? method;
  late String? title;
  late double? amountFrom;
  late double? amountTo;

  ExpensesFilter({
    this.category,
    this.dateFrom,
    this.dateTo,
    this.method,
    this.title,
    this.amountFrom,
    this.amountTo,
  }) : super();

  copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    ExpenseCategoryEnum? category,
    ExpenseMethodEnum? method,
    String? title,
    double? amountFrom,
    double? amountTo,
  }) {
    return ExpensesFilter(
      category: category ?? this.category,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      method: method ?? this.method,
      title: title ?? this.title,
      amountFrom: amountFrom ?? this.amountFrom,
      amountTo: amountTo ?? this.amountTo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpensesFilter &&
        other.dateFrom == dateFrom &&
        other.dateTo == dateTo &&
        other.category == category &&
        other.method == method &&
        other.title == title &&
        other.amountFrom == amountFrom &&
        other.amountTo == amountTo;
  }

  @override
  int get hashCode =>
      dateFrom.hashCode ^
      dateTo.hashCode ^
      category.hashCode ^
      method.hashCode ^
      title.hashCode ^
      amountFrom.hashCode ^
      amountTo.hashCode;
}
