import 'package:a_lil_bit_productive/domain/datasources/note_datasource.dart';
import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatasourceImpl implements NoteDatasource {
  late Future<Isar> isarDb;

  NoteDatasourceImpl() {
    isarDb = openIsarDb();
  }

  Future<Isar> openIsarDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync(
        [
          ReminderSchema,
          NoteSchema,
        ],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<Note> createNote({required Note note}) async {
    final isar = await isarDb;

    Note newNote = Note(
      title: note.title,
      description: note.description,
      createdAt: DateTime.now(),
      category: note.category,
    );

    return isar.writeTxn(() async {
      final noteId = await isar.notes.put(newNote);
      newNote.id = noteId;

      return newNote;
    });
  }

  @override
  Future<void> deleteNote({required int noteId}) async {
    final isar = await isarDb;
    await isar.writeTxn(() async {
      await isar.notes.where().idEqualTo(noteId).deleteFirst();
    });
  }

  @override
  Future<Note?> getNoteById({required int noteId}) async {
    final isar = await isarDb;
    return isar.notes.where().idEqualTo(noteId).findFirst();
  }

  @override
  Future<List<Note?>> getNotes({search = '', limit = 10, offset = 0}) async {
    final isar = await isarDb;

    search ??= '';
    final notes = isar.notes
        .filter()
        .optional(search != '',
            (q) => q.titleContains(search).or().descriptionContains(search))
        .sortByCreatedAt()
        .offset(offset)
        .limit(limit)
        .findAll();
    return notes;
  }

  @override
  Future<Note?> updateNote({required int noteId, required Note note}) async {
    final isar = await isarDb;
    final noteToUpdate = await isar.notes.where().idEqualTo(noteId).findFirst();
    if (noteToUpdate != null) {
      noteToUpdate.title = note.title;
      noteToUpdate.description = note.description;
      noteToUpdate.category = note.category;
      await isar.writeTxn(() async {
        await isar.notes.put(noteToUpdate);
        // await noteToUpdate.tasks.save();
      });
      return noteToUpdate;
    }
    return null;
  }
}
