import 'package:a_lil_bit_productive/presentation/views/reminders/reminder_view_item.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/reminder/reminder_notifier_provider.dart';

class RemindersView extends ConsumerStatefulWidget {
  const RemindersView({super.key});

  @override
  RemindersViewState createState() => RemindersViewState();
}

class RemindersViewState extends ConsumerState<RemindersView> {
  final ScrollController reminderListScrollController = ScrollController();
  final searchController = TextEditingController();
  Future<void> onGetReminders() async {
    await ref.read(reminderNotifierProvider.notifier).getReminders();
  }

  Future<void> onLoadMoreReminders() async {
    await ref.read(reminderNotifierProvider.notifier).loadMoreReminders();
  }

  @override
  void initState() {
    onGetReminders();
    reminderListScrollController.addListener(() async {
      if (reminderListScrollController.position.pixels + 150 >=
          reminderListScrollController.position.maxScrollExtent) {
        await onLoadMoreReminders();
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
    void onSearchReminder(String? searchQuery) {
      FocusManager.instance.primaryFocus?.unfocus();
      ref
          .read(reminderNotifierProvider.notifier)
          .getReminders(search: searchQuery);
    }

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
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  onSubmitted: (value) {
                    if (value.isEmpty) return;
                    onSearchReminder(value);
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    hintText: 'search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (searchController.text.isEmpty) return;
                            onSearchReminder(searchController.text);
                          },
                          icon: const Icon(Icons.search_outlined),
                        ),
                        if (searchController.text.isNotEmpty)
                          IconButton(
                            onPressed: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              searchController.clear();
                              ref
                                  .read(reminderNotifierProvider.notifier)
                                  .getReminders();
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onFilterByDone,
                icon: Icon(isFilteringByPending.state
                    ? Icons.filter_alt_outlined
                    : Icons.filter_alt),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            controller: reminderListScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemCount: reminderNotifier.length,
            itemBuilder: (context, index) {
              final reminder = reminderNotifier[index];
              return FadeIn(child: ReminderViewItem(reminder: reminder));
            },
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddReminder,
        heroTag: 'addReminder',
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
