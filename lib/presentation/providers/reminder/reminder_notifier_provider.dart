import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/domain/repository/reminder_repository.dart';
import 'package:a_lil_bit_productive/presentation/providers/reminder/reminder_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isFilteringByPendingProvider = StateProvider<bool>((ref) => true);

final reminderNotifierProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  final reminderRepoProvider = ref.read(reminderRepositoryImplProvider);
  return ReminderNotifier(
    reminderRepository: reminderRepoProvider,
    isFilteringByPending: ref.watch(isFilteringByPendingProvider),
  );
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  int currentPage = 0;
  bool isFetching = false;

  final ReminderRepository reminderRepository;
  final bool? isFilteringByPending;
  ReminderNotifier({
    required this.reminderRepository,
    this.isFilteringByPending,
  }) : super([]);

  Future<void> getReminders({String? search}) async {
    List<Reminder>? reminders = await reminderRepository.getReminders(
      isDone: isFilteringByPending,
      search: search,
    );

    state = reminders;
  }

  Future<void> loadMoreReminders() async {
    if (isFetching) return;
    isFetching = true;

    if (state.isNotEmpty) {
      currentPage++;
    }

    List<Reminder>? reminders = await reminderRepository.getReminders(
        isDone: isFilteringByPending, offset: currentPage * 10, limit: 10);

    state = [...state, ...reminders];
    isFetching = false;
  }

  Future<Reminder> addReminder({required Reminder reminder}) async {
    state = [reminder, ...state];

    await reminderRepository.createReminder(reminder: reminder);
    return reminder;
  }

  Future<Reminder> updateReminder({
    required int reminderId,
    required Reminder reminder,
  }) async {
    final index = state.indexWhere((r) => r.id == reminderId);

    final newReminder = await reminderRepository.updateReminder(
        reminder: reminder, reminderId: reminderId);

    state = [
      ...state.sublist(0, index),
      newReminder ?? reminder,
      ...state.sublist(index + 1),
    ];
    return reminder;
  }

  Future<Reminder?> markReminderAsDone({
    required Reminder reminder,
  }) async {
    final updatedReminder = await reminderRepository.markReminderAsDone(
      reminder: reminder,
    );

    if (updatedReminder != null) {
      final index = state.indexWhere((r) => r.id == updatedReminder.id);
      if (isFilteringByPending == true) {
        state = [
          ...state.sublist(0, index),
          ...state.sublist(index + 1),
        ];
      } else {
        state = [
          ...state.sublist(0, index),
          updatedReminder,
          ...state.sublist(index + 1),
        ];
      }
    }

    return updatedReminder;
  }

  Future<void> deleteReminder({required Reminder reminder}) async {
    await reminderRepository.deleteReminder(reminder: reminder);
    state = state.where((r) => r.id != reminder.id).toList();
  }
}
