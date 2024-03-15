import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/models/models.dart';
import '../../../helpers/color_helper.dart';
import '../../providers/providers.dart';
import '../../views/notes/note_category_helper.dart';

class NewNoteScreen extends ConsumerStatefulWidget {
  final int? noteId;
  const NewNoteScreen({this.noteId, super.key});

  @override
  NewNoteScreenState createState() => NewNoteScreenState();
}

class NewNoteScreenState extends ConsumerState<NewNoteScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  bool isButtonDisabled = true;
  CategoriesEnum selectedCategory = CategoriesEnum.others;
  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();

    if (widget.noteId != null) {
      onGetNoteById().then((note) {
        if (note != null) {
          titleController.text = note.title;
          descriptionController.text = note.description ?? '';
          selectedCategory = note.category;
          setState(() {
            isButtonDisabled = false;
          });
        }
      });
    }
  }

  Future<Note?> onGetNoteById() async {
    if (widget.noteId == null) return null;
    return await ref
        .read(noteRepositoryImplProvider)
        .getNoteById(noteId: widget.noteId!);
  }

  void saveNote() async {
    final note = Note(
      title: titleController.text,
      description: descriptionController.text,
      category: selectedCategory,
    );

    if (widget.noteId == null) {
      await ref.read(noteNotifierProvider.notifier).addNote(note: note);
    } else {
      await ref
          .read(noteNotifierProvider.notifier)
          .updateNote(note: note, noteId: widget.noteId!);
    }

    setState(() {
      isButtonDisabled = true;
    });

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('reminder created successfully!'),
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 10,
        ),
        behavior: SnackBarBehavior.fixed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      GoRouter.of(context).go('/base/1');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId != null ? 'Edit Note' : 'New Note'),
        actions: [
          TextButton(
            onPressed: isButtonDisabled ? null : saveNote,
            child: const Text(
              'save',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
          child: Column(children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children: [
                  ...CategoriesEnum.values.map(
                    (category) {
                      final accentColor =
                          NoteCategoryHelper.categoryColors[category.index];
                      return FilterChip(
                        backgroundColor: accentColor.withOpacity(0.3),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              selectedCategory = category;
                            });
                          }
                        },
                        selectedColor: accentColor.withOpacity(0.7),
                        selected: category.name == selectedCategory.name,
                        label: Text(category.name),
                      );
                    },
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(children: [
                TextField(
                  autofocus: true,
                  controller: titleController,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                  minLines: 1,
                  maxLines: 2,
                  onChanged: (value) {
                    setState(() {
                      isButtonDisabled = value.isEmpty;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'title',
                    hintStyle: TextStyle(fontSize: 40),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  minLines: 5,
                  maxLines: 20,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'more details',
                  ),
                ),
              ]),
            ),
          ])),
    );
  }
}
