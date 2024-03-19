import 'package:isar/isar.dart';

part 'note.g.dart';

enum NoteCategoriesEnum { work, school, personal, others }

@collection
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String? description;
  late DateTime? createdAt;

  @enumerated
  late NoteCategoriesEnum category;

  Note({
    required this.title,
    this.description,
    this.createdAt,
    this.category = NoteCategoriesEnum.others,
  });

  copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    NoteCategoriesEnum? category,
  }) {
    return Note(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}
