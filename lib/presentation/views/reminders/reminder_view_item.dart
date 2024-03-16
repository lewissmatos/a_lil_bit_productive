import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../domain/entities/reminder.dart';
import '../../../helpers/color_helper.dart';
import '../../providers/reminder/reminder_notifier_provider.dart';

class ReminderViewItem extends ConsumerStatefulWidget {
  final Reminder reminder;
  const ReminderViewItem({super.key, required this.reminder});

  @override
  ReminderViewItemState createState() => ReminderViewItemState();
}

class ReminderViewItemState extends ConsumerState<ReminderViewItem> {
  void onMarkReminderAsDone() async {
    final reminderNotifier = ref.read(reminderNotifierProvider.notifier);

    await reminderNotifier.markReminderAsDone(reminder: widget.reminder);
  }

  @override
  Widget build(BuildContext context) {
    final reminderAccentColor =
        ColorHelper.getColorFromHex(widget.reminder.color) ??
            Theme.of(context).primaryColor;

    void onGoToReminderDetails() {
      context.push('/base/0/reminder/${widget.reminder.id}');
    }

    Future<bool> confirmDismiss() async {
      return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    const Text("Are you sure you want to delete this item?"),
                actions: <Widget>[
                  TextButton(
                      onPressed: () {
                        ref
                            .read(reminderNotifierProvider.notifier)
                            .deleteReminder(reminder: widget.reminder);
                        Navigator.of(context).pop(true);
                      },
                      child: const Text("DELETE",
                          style: TextStyle(color: Colors.red))),
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Dismissible(
          key: Key(
            widget.reminder.id.toString(),
          ),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              onMarkReminderAsDone();
              return false;
            }
            return await confirmDismiss();
          },
          background: DismissibleItemBackground(isDone: widget.reminder.isDone),
          secondaryBackground: const DismissibleItemSecondaryBackground(),
          child: GestureDetector(
            onTap: onGoToReminderDetails,
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 0,
              margin: const EdgeInsets.all(0),
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if (widget.reminder.description != null)
                                Text(
                                  widget.reminder.description ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: widget.reminder.isDone,
                          onChanged: (value) {
                            onMarkReminderAsDone();
                          },
                          activeColor: reminderAccentColor,
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    if (widget.reminder.tags != null)
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: [
                          ...widget.reminder.tags!,
                        ].take(10).map((tag) {
                          return Container(
                            // margin: const EdgeInsets.only(right: 5),
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
                    Container(
                      padding: const EdgeInsets.only(top: 3),
                      alignment: Alignment.centerRight,
                      child: Text(
                        DateFormat.yMMMEd()
                            .add_Hm()
                            .format(widget.reminder.date),
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DismissibleItemBackground extends StatelessWidget {
  final bool isDone;
  const DismissibleItemBackground({
    super.key,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !isDone ? Colors.green : Colors.orange,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 20),
            Icon(!isDone ? Icons.check : Icons.close_outlined,
                color: Colors.white),
            Text(!isDone ? " mark as done" : " mark as undone",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}

class DismissibleItemSecondaryBackground extends StatelessWidget {
  const DismissibleItemSecondaryBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
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
