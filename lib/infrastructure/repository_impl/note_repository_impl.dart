import 'package:a_lil_bit_productive/domain/datasources/note_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/note_repository.dart';

import '../../domain/entities/entities.dart';

class NoteRepositoryImpl extends NoteRepository {
  final NoteDataSource noteDataSource;

  NoteRepositoryImpl({required this.noteDataSource});

  @override
  Future<Note?> createNote({required Note note}) async {
    return await noteDataSource.createNote(note: note);
  }

  @override
  Future<void> deleteNote({required int noteId}) async {
    return await noteDataSource.deleteNote(noteId: noteId);
  }

  @override
  Future<Note?> getNoteById({required int noteId}) async {
    return await noteDataSource.getNoteById(noteId: noteId);
  }

  @override
  Future<List<Note?>> getNotes({search = '', limit = 10, offset = 0}) async {
    return await noteDataSource.getNotes(
        search: search, limit: limit, offset: offset);
  }

  @override
  Future<Note?> updateNote({required int noteId, required Note note}) async {
    return await noteDataSource.updateNote(noteId: noteId, note: note);
  }
}
