import 'package:a_lil_bit_productive/domain/entities/expense.dart';
import 'package:a_lil_bit_productive/helpers/expense_method_helper.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NewExpenseMethodSelector extends StatefulWidget {
  Expense expense;
  final void Function(Expense expense) updateExpense;

  NewExpenseMethodSelector({
    super.key,
    required this.expense,
    required this.updateExpense,
  });

  @override
  State<NewExpenseMethodSelector> createState() =>
      _NewExpenseMethodSelectorState();
}

class _NewExpenseMethodSelectorState extends State<NewExpenseMethodSelector> {
  @override
  void initState() {
    super.initState();
  }

  void setMethod(ExpenseMethodEnum method) {
    setState(() {
      widget.updateExpense(widget.expense.copyWith(method: method));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      direction: Axis.horizontal,
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ...ExpenseMethodEnum.values.map(
          (method) {
            bool isSelected = method == widget.expense.method;
            Color accentColor = isSelected
                ? ExpenseMethodHelper.getExpenseMethod(method).color
                : Colors.grey[600]!;
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                color: accentColor.withOpacity(0.3),
                width: MediaQuery.of(context).size.width * 0.3,
                height: 150,
                child: InkWell(
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onTap: () {
                    setState(() {
                      setMethod(method);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                method.name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: accentColor,
                                ),
                            ],
                          ),
                        ),
                        Center(
                          child: Container(
                              margin: const EdgeInsets.only(top: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: accentColor.withOpacity(0.2),
                              ),
                              child: Icon(
                                ExpenseMethodHelper.getExpenseMethod(method)
                                    .icon,
                                color: accentColor,
                                size: 50,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
