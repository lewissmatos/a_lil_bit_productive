import '../entities/entities.dart';

abstract class ReminderDataSource {
  Future<List<Reminder>> getReminders({
    search = '',
    limit = 10,
    offset = 0,
    DateTime? date,
    bool? isDone,
  });

  Future<Reminder?> getReminderById({required int reminderId});

  Future<Reminder> createReminder({required Reminder reminder});

  Future<Reminder?> updateReminder(
      {required int reminderId, required Reminder reminder});

  Future<void> deleteReminder({required Reminder reminder});

  Future<Reminder?> markReminderAsDone({required Reminder reminder});
}
