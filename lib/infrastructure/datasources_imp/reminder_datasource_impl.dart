import 'package:a_lil_bit_productive/domain/datasources/reminder_datasource.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/models.dart';

class ReminderDatasourceImpl extends ReminderDatasource {
  late Future<Isar> isarDb;

  ReminderDatasourceImpl() {
    isarDb = openIsarDb();
  }

  Future<Isar> openIsarDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return await Isar.open(
        [ReminderSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<Reminder> createReminder({required Reminder reminder}) async {
    final isar = await isarDb;

    reminder = reminder.copyWith(createdAt: DateTime.now());
    isar.writeTxn(() async {
      await isar.reminders.put(reminder);
    });

    return reminder;
  }

  @override
  Future<List<Reminder>> getReminders(
      {search = '',
      limit = 10,
      offset = 0,
      DateTime? date,
      bool isDone = false}) async {
    final isar = await isarDb;

    var query = isar.reminders.where().filter();
    if (search != '') {
      query = query.titleContains(search).descriptionContains(search);
    }

    final reminders = await query
        .isDoneEqualTo(isDone)
        .sortByDate()
        .offset(offset)
        .limit(limit)
        .findAll();

    return reminders;
  }

  @override
  Future<void> deleteReminder({required Reminder reminder}) {
    // TODO: implement deleteReminder
    throw UnimplementedError();
  }

  @override
  Future<Reminder?> markReminderAsDone({required Reminder reminder}) async {
    final isar = await isarDb;

    Reminder? reminderToUpdate =
        await isar.reminders.where().idEqualTo(reminder.id).findFirst();

    if (reminderToUpdate == null) return null;
    reminderToUpdate.isDone = true;
    isar.writeTxn(() async {
      await isar.reminders.put(reminderToUpdate);
    });

    return reminderToUpdate;
  }

  @override
  Future<Reminder> updateReminder({required Reminder reminder}) {
    // TODO: implement updateReminder
    throw UnimplementedError();
  }
}
