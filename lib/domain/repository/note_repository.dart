import '../entities/entities.dart';

abstract class NoteRepository {
  Future<List<Note?>> getNotes({
    search = '',
    limit = 10,
    offset = 0,
  });

  Future<Note?> getNoteById({required int noteId});

  Future<Note?> createNote({required Note note});

  Future<Note?> updateNote({required int noteId, required Note note});

  Future<void> deleteNote({required int noteId});
}
