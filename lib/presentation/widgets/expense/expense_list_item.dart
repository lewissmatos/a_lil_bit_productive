import 'package:a_lil_bit_productive/helpers/expense_category_helper.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/entities.dart';
import '../../providers/providers.dart';

class ExpenseListItem extends ConsumerStatefulWidget {
  final ExpenseCategoryDecorator expenseCategoryDecorator;
  final Expense expense;
  const ExpenseListItem({
    super.key,
    required this.expense,
    required this.expenseCategoryDecorator,
  });

  @override
  ExpenseListItemState createState() => ExpenseListItemState();
}

class ExpenseListItemState extends ConsumerState<ExpenseListItem> {
  @override
  void initState() {
    super.initState();
  }

  void deleteExpense() async {
    await ref
        .read(expenseNotifierProvider.notifier)
        .deleteExpense(expense: widget.expense);
  }

  Future<bool> confirmDismiss() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Confirm"),
              content: const Text("Are you sure you want to delete this item?"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      deleteExpense();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "DELETE",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL"),
                ),
              ],
            );
          },
        ) ??
        false; // In case the user dismisses the dialog by clicking away from it
  }

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      child: Dismissible(
        key: Key(widget.expense.id.toString()),
        background: const DismissibleItemBackground(),
        direction: DismissDirection
            .endToStart, // allow swiping only from right to left
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            deleteExpense();
          }
        },
        confirmDismiss: (direction) async {
          return await confirmDismiss();
        },
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
          onTap: () {
            context.push('/base/2/expense/${widget.expense.id}');
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          leading: CircleAvatar(
            backgroundColor: widget.expenseCategoryDecorator.color,
            child: Icon(
              widget.expenseCategoryDecorator.icon,
              color: Colors.white,
            ),
          ),
          title: Text(
            widget.expense.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
          subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.expense.method.name,
                  style: TextStyle(
                    color: ExpenseMethodHelper.getExpenseMethod(
                      widget.expense.method,
                    ).color,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  widget.expense.method == ExpenseMethodEnum.Cash
                      ? Icons.money_rounded
                      : Icons.credit_card_rounded,
                  size: 14,
                  color: ExpenseMethodHelper.getExpenseMethod(
                    widget.expense.method,
                  ).color,
                ),
              ]),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-\$${widget.expense.amount.toStringAsFixed(1)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.expense.date != null)
                Text(
                  DateFormat.yMMMd().add_Hm().format(widget.expense.date!),
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class DismissibleItemBackground extends StatelessWidget {
  const DismissibleItemBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.white),
            Text(" Delete",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
