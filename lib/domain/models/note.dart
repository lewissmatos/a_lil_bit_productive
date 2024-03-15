import 'package:a_lil_bit_productive/domain/models/models.dart';
import 'package:isar/isar.dart';

part 'note.g.dart';

enum CategoriesEnum { work, school, personal, others }

@collection
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String? description;
  late DateTime? createdAt;

  @enumerated
  late CategoriesEnum category;

  Note({
    required this.title,
    this.description,
    this.createdAt,
    this.category = CategoriesEnum.others,
  });

  copyWith({
    String? title,
    String? description,
    DateTime? createdAt,
    CategoriesEnum? category,
  }) {
    return Note(
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      category: category ?? this.category,
    );
  }
}
