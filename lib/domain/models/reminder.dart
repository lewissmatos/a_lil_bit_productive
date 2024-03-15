import 'package:isar/isar.dart';

part 'reminder.g.dart';

@collection
class Reminder {
  Id id = Isar.autoIncrement;
  late String title;
  late String? description;
  late DateTime date;
  late DateTime? createdAt;
  late bool isDone;
  late List<String>? tags;
  late String? color;

  Reminder({
    required this.title,
    this.description,
    required this.date,
    this.isDone = false,
    this.tags = const [],
    this.color,
    this.createdAt,
  });

  Reminder copyWith({
    String? title,
    String? description,
    DateTime? date,
    bool? isDone,
    List<String>? tags,
    String? color,
    DateTime? createdAt,
  }) {
    return Reminder(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      tags: tags ?? this.tags,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
