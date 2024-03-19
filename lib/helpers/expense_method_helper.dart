import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:flutter/material.dart';

class ExpenseMethodDecorator {
  final Color color;
  final IconData icon;

  ExpenseMethodDecorator({required this.color, required this.icon});
}

typedef MethodMap = Map<ExpenseMethodEnum, Expense>;

class ExpenseMethodHelper {
  static final Map<String, ExpenseMethodDecorator> expenseDecorators = {
    ExpenseMethodEnum.Cash.name:
        ExpenseMethodDecorator(color: Colors.green, icon: Icons.money),
    ExpenseMethodEnum.Credit.name: ExpenseMethodDecorator(
        color: Colors.amber, icon: Icons.credit_card_outlined),
    ExpenseMethodEnum.Loan.name: ExpenseMethodDecorator(
        color: Colors.red, icon: Icons.handshake_outlined),
  };

  static ExpenseMethodDecorator getExpenseMethod(ExpenseMethodEnum method) {
    final color = expenseDecorators[method.name]!.color;
    final icon = expenseDecorators[method.name]!.icon;
    return ExpenseMethodDecorator(color: color, icon: icon);
  }
}
