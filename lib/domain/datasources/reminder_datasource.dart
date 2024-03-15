import '../models/models.dart';

abstract class ReminderDatasource {
  Future<List<Reminder>> getReminders({
    search = '',
    limit = 10,
    offset = 0,
    DateTime? date,
  });

  Future<Reminder> createReminder({required Reminder reminder});

  Future<Reminder> updateReminder({required Reminder reminder});

  Future<void> deleteReminder({required Reminder reminder});

  Future<Reminder?> markReminderAsDone({required Reminder reminder});
}
