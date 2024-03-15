import 'package:a_lil_bit_productive/domain/datasources/reminder_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/reminder_repository.dart';

import '../../domain/models/models.dart';

class ReminderRepositoryImpl extends ReminderRepository {
  final ReminderDatasource reminderDatasource;

  ReminderRepositoryImpl({required this.reminderDatasource});

  @override
  Future<Reminder> createReminder({required Reminder reminder}) async {
    return await reminderDatasource.createReminder(reminder: reminder);
  }

  @override
  Future<List<Reminder>> getReminders(
      {search = '', limit = 10, int offset = 0, DateTime? date}) async {
    return await reminderDatasource.getReminders(
        search: search, limit: limit, offset: offset, date: date);
  }

  @override
  Future<void> deleteReminder({required Reminder reminder}) {
    // TODO: implement deleteReminder
    throw UnimplementedError();
  }

  @override
  Future<Reminder?> markReminderAsDone({required Reminder reminder}) async {
    return await reminderDatasource.markReminderAsDone(reminder: reminder);
  }

  @override
  Future<Reminder> updateReminder({required Reminder reminder}) {
    // TODO: implement updateReminder
    throw UnimplementedError();
  }
}
