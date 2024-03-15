import 'package:a_lil_bit_productive/presentation/views/notes/note_category_helper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/models.dart';
import '../../providers/providers.dart';

class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key});

  @override
  NotesViewState createState() => NotesViewState();
}

class NotesViewState extends ConsumerState<NotesView> {
  final ScrollController masonryScrollController = ScrollController();
  @override
  void initState() {
    ref.read(noteNotifierProvider.notifier).getNotes();
    masonryScrollController.addListener(() async {
      if (masonryScrollController.position.pixels + 150 >=
          masonryScrollController.position.maxScrollExtent) {
        await ref.read(noteNotifierProvider.notifier).loadMoreNotes();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    masonryScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Note?> notes = ref.watch(noteNotifierProvider);
    void onAddNote() {
      context.push('/base/0/new-note');
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: onAddNote,
        heroTag: 'addNote',
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: MasonryGridView.count(
          controller: masonryScrollController,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          itemCount: notes.length,
          itemBuilder: (context, index) {
            Note note = notes[index]!;
            return FadeInUp(child: NoteItem(note: note));
          },
        ),
      ),
    );
  }
}

class NoteItem extends StatefulWidget {
  final Note note;
  const NoteItem({super.key, required this.note});

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  @override
  Widget build(BuildContext context) {
    void onGoToNoteDetails() {
      context.push('/base/1/note/${widget.note.id}');
    }

    return GestureDetector(
      onTap: onGoToNoteDetails,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: NoteCategoryHelper().getCategory(widget.note.category).color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      widget.note.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    width: 40,
                    height: 40,
                    child: Center(
                      child: Text(
                        NoteCategoryHelper()
                            .getCategory(widget.note.category)
                            .emoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              Text(
                widget.note.description ?? '',
                style: const TextStyle(fontSize: 14),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        ),
      ),
    );
  }
}
