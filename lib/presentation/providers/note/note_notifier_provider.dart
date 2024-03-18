import 'package:a_lil_bit_productive/domain/entities/entities.dart';
import 'package:a_lil_bit_productive/domain/repository/note_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';

final noteNotifierProvider = StateNotifierProvider<NoteNotifier, List<Note?>>(
  (ref) {
    final noteRepoProvider = ref.read(noteRepositoryImplProvider);
    return NoteNotifier(
      noteRepository: noteRepoProvider,
    );
  },
);

class NoteNotifier extends StateNotifier<List<Note?>> {
  int currentPage = 0;
  bool isFetching = false;

  final NoteRepository noteRepository;
  NoteNotifier({
    required this.noteRepository,
  }) : super([]);

  Future<Note?> addNote({required Note note}) async {
    Note? newNote = await noteRepository.createNote(
      note: note,
    );
    state = [newNote ?? note, ...state];
    return newNote;
  }

  Future<Note?> updateNote({required int noteId, required Note note}) async {
    final index = state.indexWhere((n) => n?.id == noteId);
    Note? newNote = await noteRepository.updateNote(
      noteId: noteId,
      note: note,
    );

    state = [
      ...state.sublist(0, index),
      newNote,
      ...state.sublist(index + 1),
    ];
    return newNote;
  }

  Future<void> getNotes({String? search}) async {
    List<Note?> notes = await noteRepository.getNotes(
      search: search,
      offset: 0,
      limit: 20,
    );

    state = notes;
  }

  Future<void> loadMoreNotes() async {
    if (isFetching) return;
    isFetching = true;

    if (state.isNotEmpty) {
      currentPage++;
    }

    List<Note?> notes =
        await noteRepository.getNotes(offset: currentPage * 10, limit: 10);

    state = [...state, ...notes];
    isFetching = false;
  }

  Future<void> deleteNote({
    required int noteId,
  }) async {
    await noteRepository.deleteNote(
      noteId: noteId,
    );
    state = state.where((n) => n?.id != noteId).toList();
  }
}
