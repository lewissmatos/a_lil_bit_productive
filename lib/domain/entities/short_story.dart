import 'package:isar/isar.dart';

part 'short_story.g.dart';

@collection
class ShortStory {
  Id id = Isar.autoIncrement;
  late String storyId;
  late String title;
  late String description;
  late String? moral;
  late String? author;
  late bool isBookmarked;

  ShortStory({
    required this.storyId,
    required this.title,
    required this.description,
    this.moral,
    this.author,
    this.isBookmarked = false,
  });

  copyWith({
    String? storyId,
    required String title,
    required String description,
    String? moral,
    String? author,
  }) {
    return ShortStory(
      storyId: storyId ?? this.storyId,
      title: title,
      description: description,
      moral: moral ?? this.moral,
      isBookmarked: isBookmarked,
    );
  }
}
