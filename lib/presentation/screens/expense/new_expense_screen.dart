import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/presentation/widgets/shared/custom_filled_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class NewExpenseScreen extends ConsumerStatefulWidget {
  final int? expenseId;
  const NewExpenseScreen({
    super.key,
    this.expenseId,
  });

  @override
  NewExpenseScreenState createState() => NewExpenseScreenState();
}

class NewExpenseScreenState extends ConsumerState<NewExpenseScreen> {
  Expense expense = Expense(
    title: '',
    amount: 0,
    category: ExpenseCategoryEnum.Others,
    method: ExpenseMethodEnum.Cash,
    date: DateTime.now(),
  );
  late bool isButtonDisabled = false;
  late TextEditingController amountController;
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    isButtonDisabled = true;
    amountController = TextEditingController();
    titleController = TextEditingController();
    if (widget.expenseId != null) {
      onGetExpense();
    }
  }

  Future<void> onGetExpense() async {
    final curExpense = await ref
        .read(expenseRepositoryImplProvider)
        .getExpense(id: widget.expenseId!);

    if (curExpense == null) return;
    setState(() {
      expense = expense.copyWith(
        amount: curExpense.amount,
        category: curExpense.category,
        method: curExpense.method,
        title: curExpense.title,
        date: curExpense.date,
      );

      amountController.text = curExpense.amount.toString();
      titleController.text = curExpense.title;
    });
  }

  void updateCurrentExpense(Expense expenseData) {
    setState(() {
      expense = expense.copyWith(
        amount: expenseData.amount,
        category: expenseData.category,
        method: expenseData.method,
        title: expenseData.title,
        date: expenseData.date,
      );
      isButtonDisabled = expense.amount == 0 || expense.title.isEmpty;
    });
  }

  void onOpenDatePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: expense.date ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (selectedDate == null) return;
    expense = expense.copyWith(
      date: DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        expense.date?.hour ?? DateTime.now().hour,
        expense.date?.minute ?? DateTime.now().minute,
      ),
    );

    updateCurrentExpense(expense);
  }

  void onOpenTimePicker() async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: expense.date?.hour != null
          ? TimeOfDay(hour: expense.date!.hour, minute: expense.date!.minute)
          : TimeOfDay.now(),
    );

    if (selectedTime == null) return;
    final now = DateTime.now();
    expense = expense.copyWith(
      date: DateTime(
        expense.date?.year ?? now.year,
        expense.date?.month ?? now.year,
        expense.date?.day ?? now.year,
        selectedTime.hour,
        selectedTime.minute,
      ),
    );

    updateCurrentExpense(expense);
  }

  void saveExpense() async {
    if (widget.expenseId == null) {
      await ref
          .read(expenseNotifierProvider.notifier)
          .addExpense(expense: expense);
    } else {
      await ref
          .read(expenseNotifierProvider.notifier)
          .updateExpense(expense: expense, expenseId: widget.expenseId!);
    }
    // ignore: use_build_context_synchronously
    context.go('/base/2');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Expense'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              TextField(
                controller: amountController,
                autofocus: true,
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ), // display numeric keyboard with decimal
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d*')), // allow only double
                ],
                onChanged: (value) {
                  expense = expense.copyWith(
                    amount: double.tryParse(value) ?? 0,
                  );
                  updateCurrentExpense(expense);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  hintText: '0.00',
                  hintStyle: TextStyle(fontSize: 40),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomFilledTextField(
                controller: titleController,
                hintText: 'enter title',
                onChanged: (value) {
                  isButtonDisabled = value.isEmpty;
                  expense = expense.copyWith(
                    title: value,
                  );
                  updateCurrentExpense(expense);
                },
              ),
              const SizedBox(height: 15),
              ExpenseCategorySelector(
                expense: expense,
                updateExpense: updateCurrentExpense,
              ),
              const SizedBox(height: 10),
              NewExpenseMethodSelector(
                expense: expense,
                updateExpense: updateCurrentExpense,
              ),
              const SizedBox(height: 15),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: ElevatedButton.icon(
                      onPressed: onOpenDatePicker,
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        DateFormat('yyyy-MM-dd')
                            .format(expense.date ?? DateTime.now()),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: ElevatedButton.icon(
                      onPressed: onOpenTimePicker,
                      icon: const Icon(Icons.timer_outlined),
                      label: Text(
                        DateFormat('HH:mm')
                            .format(expense.date ?? DateTime.now()),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: isButtonDisabled ? null : saveExpense,
                label: const Text('save expense'),
                icon: const Icon(Icons.save_outlined),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                ),
              ),
            ],
          ),
        ));
  }
}
