import 'package:a_lil_bit_productive/domain/datasources/reminder_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/reminder_repository.dart';

import '../../domain/entities/entities.dart';

class ReminderRepositoryImpl extends ReminderRepository {
  final ReminderDataSource reminderDataSource;

  ReminderRepositoryImpl({required this.reminderDataSource});

  @override
  Future<Reminder> createReminder({required Reminder reminder}) async {
    return await reminderDataSource.createReminder(reminder: reminder);
  }

  @override
  Future<List<Reminder>> getReminders(
      {search = '',
      limit = 10,
      int offset = 0,
      DateTime? date,
      bool? isDone}) async {
    return await reminderDataSource.getReminders(
      search: search,
      limit: limit,
      offset: offset,
      date: date,
      isDone: isDone,
    );
  }

  @override
  Future<void> deleteReminder({required Reminder reminder}) async {
    return await reminderDataSource.deleteReminder(reminder: reminder);
  }

  @override
  Future<Reminder?> markReminderAsDone({required Reminder reminder}) async {
    return await reminderDataSource.markReminderAsDone(reminder: reminder);
  }

  @override
  Future<Reminder?> updateReminder(
      {required int reminderId, required Reminder reminder}) async {
    return await reminderDataSource.updateReminder(
        reminder: reminder, reminderId: reminderId);
  }

  @override
  Future<Reminder?> getReminderById({required int reminderId}) async {
    return await reminderDataSource.getReminderById(reminderId: reminderId);
  }
}
