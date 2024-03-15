import 'package:a_lil_bit_productive/domain/datasources/note_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/note_repository.dart';

import '../../domain/models/models.dart';

class NoteRepositoryImpl extends NoteRepository {
  final NoteDatasource noteDatasource;

  NoteRepositoryImpl({required this.noteDatasource});

  @override
  Future<Note?> createNote({required Note note}) async {
    return await noteDatasource.createNote(note: note);
  }

  @override
  Future<void> deleteNote({required Note note}) async {
    return await noteDatasource.deleteNote(note: note);
  }

  @override
  Future<Note?> getNoteById({required int noteId}) async {
    return await noteDatasource.getNoteById(noteId: noteId);
  }

  @override
  Future<List<Note?>> getNotes({search = '', limit = 10, offset = 0}) async {
    return await noteDatasource.getNotes(
        search: search, limit: limit, offset: offset);
  }

  @override
  Future<Note?> updateNote({required int noteId, required Note note}) async {
    return await noteDatasource.updateNote(noteId: noteId, note: note);
  }
}
