import 'package:a_lil_bit_productive/domain/models/models.dart';
import 'package:a_lil_bit_productive/helpers/color_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../providers/reminder/reminder_notifier_provider.dart';

class RemindersView extends ConsumerStatefulWidget {
  const RemindersView({super.key});

  @override
  RemindersViewState createState() => RemindersViewState();
}

class RemindersViewState extends ConsumerState<RemindersView> {
  @override
  void initState() {
    super.initState();
    ref.read(reminderNotifierProvider.notifier).getReminders();
  }

  @override
  Widget build(BuildContext context) {
    final reminderNotifier = ref.watch(reminderNotifierProvider);
    void onAddReminder() {
      context.push('/base/0/new-reminder');
    }

    return Scaffold(
      body: Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          itemCount: reminderNotifier.length,
          itemBuilder: (context, index) {
            final reminder = reminderNotifier[index];
            return FadeInUp(child: ReminderItem(reminder: reminder));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddReminder,
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}

class ReminderItem extends ConsumerStatefulWidget {
  final Reminder reminder;
  const ReminderItem({super.key, required this.reminder});

  @override
  ReminderItemState createState() => ReminderItemState();
}

class ReminderItemState extends ConsumerState<ReminderItem> {
  void onMarkReminderAsDone() async {
    final reminderNotifier = ref.read(reminderNotifierProvider.notifier);

    await reminderNotifier.markReminderAsDone(reminder: widget.reminder);
  }

  @override
  Widget build(BuildContext context) {
    final reminderAccentColor =
        ColorHelper.getColorFromHex(widget.reminder.color);
    return Card(
      elevation: 0,
      color: reminderAccentColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reminder.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                      if (widget.reminder.description != null)
                        Text(
                          widget.reminder.description ?? '',
                          maxLines: 3,
                        ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat.yMMMEd().add_Hm().format(widget.reminder.date),
                      style: const TextStyle(fontSize: 12),
                    ),
                    Checkbox(
                      value: widget.reminder.isDone,
                      onChanged: (value) {
                        onMarkReminderAsDone();
                      },
                      activeColor: reminderAccentColor,
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 4),
            if (widget.reminder.tags != null)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.reminder.tags!.map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 5),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: reminderAccentColor.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
