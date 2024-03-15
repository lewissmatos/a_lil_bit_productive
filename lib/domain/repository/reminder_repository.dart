import '../models/models.dart';

abstract class ReminderRepository {
  Future<List<Reminder>> getReminders({
    search = '',
    limit = 10,
    int offset = 0,
    bool? isDone,
    DateTime date,
  });

  Future<Reminder> createReminder({required Reminder reminder});

  Future<Reminder> updateReminder({required Reminder reminder});

  Future<void> deleteReminder({required Reminder reminder});

  Future<Reminder?> markReminderAsDone({required Reminder reminder});
}
