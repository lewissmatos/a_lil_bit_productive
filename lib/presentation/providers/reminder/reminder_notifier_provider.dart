import 'package:a_lil_bit_productive/domain/models/models.dart';
import 'package:a_lil_bit_productive/domain/repository/reminder_repository.dart';
import 'package:a_lil_bit_productive/presentation/providers/reminder/reminder_impl_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reminderNotifierProvider =
    StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  final reminderRepoProvider = ref.read(reminderRepositoryImplProvider);
  return ReminderNotifier(
    reminderRepository: reminderRepoProvider,
  );
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final ReminderRepository reminderRepository;

  ReminderNotifier({required this.reminderRepository}) : super([]);

  Future<void> getReminders() async {
    state = await reminderRepository.getReminders();
  }

  Future<Reminder> addReminder({required Reminder reminder}) async {
    state = [
      reminder,
      ...state,
    ];

    await reminderRepository.createReminder(reminder: reminder);

    return reminder;
  }

  Future<Reminder?> markReminderAsDone({required Reminder reminder}) async {
    final updatedReminder = await reminderRepository.markReminderAsDone(
      reminder: reminder,
    );

    if (updatedReminder != null) {
      final index = state.indexWhere((r) => r.id == updatedReminder.id);
      state = [
        ...state.sublist(0, index),
        updatedReminder,
        ...state.sublist(index + 1),
      ];
    }

    return updatedReminder;
  }
}
