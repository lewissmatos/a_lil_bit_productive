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
  final ScrollController reminderListScrollController = ScrollController();

  Future<void> onGetReminders() async {
    await ref.read(reminderNotifierProvider.notifier).getReminders();
  }

  @override
  void initState() {
    onGetReminders();

    reminderListScrollController.addListener(() async {
      if (reminderListScrollController.position.pixels + 250 >=
          reminderListScrollController.position.maxScrollExtent) {
        await onGetReminders();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    reminderListScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFilteringByPending =
        ref.watch(isFilteringByPendingProvider.notifier);

    final reminderNotifier = ref.watch(reminderNotifierProvider);
    void onAddReminder() {
      context.push('/base/0/new-reminder');
    }

    void onFilterByDone() async {
      isFilteringByPending.state = !isFilteringByPending.state;
      await onGetReminders();
    }

    return Scaffold(
      body: Column(children: [
        Container(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed: onFilterByDone,
                icon: const Icon(Icons.filter_alt_outlined, size: 18),
                label: Text(isFilteringByPending.state
                    ? 'pending: ${reminderNotifier.length}'
                    : 'all: ${reminderNotifier.length}'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: reminderListScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: reminderNotifier.length,
            itemBuilder: (context, index) {
              final reminder = reminderNotifier[index];
              return FadeIn(child: ReminderItem(reminder: reminder));
            },
          ),
        ),
      ]),
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
        ColorHelper.getColorFromHex(widget.reminder.color) ??
            Theme.of(context).primaryColor;

    void onGoToReminderDetails() {
      context.push('/base/0/reminder/${widget.reminder.id}');
    }

    return GestureDetector(
      onTap: onGoToReminderDetails,
      child: Card(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        DateFormat.yMMMEd()
                            .add_Hm()
                            .format(widget.reminder.date),
                        style: const TextStyle(fontSize: 11),
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
      ),
    );
  }
}
