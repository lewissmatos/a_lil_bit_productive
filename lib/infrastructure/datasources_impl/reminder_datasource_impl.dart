import 'package:a_lil_bit_productive/domain/datasources/reminder_datasource.dart';
import '../../domain/entities/entities.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class ReminderDatasourceImpl extends ReminderDatasource {
  late Future<Isar> isarDb;

  ReminderDatasourceImpl() {
    isarDb = openIsarDb();
  }

  Future<Isar> openIsarDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync(
        [
          ReminderSchema,
          NoteSchema,
          ShortStorySchema,
        ],
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
      bool? isDone}) async {
    final isar = await isarDb;

    var remindersQuery = isar.reminders;

    List<Reminder> reminders;

    isDone ??= true;
    search ??= '';

    reminders = await remindersQuery
        .filter()
        .optional(isDone == true, (q) => q.isDoneEqualTo(!isDone!))
        .optional(
            search != '',
            (q) => q
                .titleContains(search)
                .or()
                .descriptionContains(search)
                .or()
                .tagsElementContains(search))
        .sortByDate()
        .offset(offset)
        .limit(limit)
        .findAll();

    return reminders;
  }

  @override
  Future<Reminder?> markReminderAsDone({required Reminder reminder}) async {
    final isar = await isarDb;

    Reminder? reminderToUpdate =
        await isar.reminders.where().idEqualTo(reminder.id).findFirst();

    if (reminderToUpdate == null) return null;
    reminderToUpdate.isDone = !reminder.isDone;
    isar.writeTxn(() async {
      await isar.reminders.put(reminderToUpdate);
    });

    return reminderToUpdate;
  }

  @override
  Future<Reminder?> updateReminder({
    required int reminderId,
    required Reminder reminder,
  }) async {
    final isar = await isarDb;

    var reminderToUpdate =
        await isar.reminders.where().idEqualTo(reminderId).findFirst();

    if (reminderToUpdate == null) return null;

    reminderToUpdate.title = reminder.title;
    reminderToUpdate.description = reminder.description;
    reminderToUpdate.date = reminder.date;
    reminderToUpdate.isDone = reminder.isDone;
    reminderToUpdate.color = reminder.color;

    await isar.writeTxn(() async {
      await isar.reminders.put(reminderToUpdate);
    });

    return reminderToUpdate;
  }

  @override
  Future<void> deleteReminder({required Reminder reminder}) async {
    final isar = await isarDb;

    await isar.writeTxn(() async {
      await isar.reminders.where().idEqualTo(reminder.id).deleteFirst();
    });
  }

  @override
  Future<Reminder?> getReminderById({required int reminderId}) async {
    final isar = await isarDb;

    return await isar.reminders.where().idEqualTo(reminderId).findFirst();
  }
}
