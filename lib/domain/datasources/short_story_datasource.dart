import '../entities/entities.dart';

abstract class ShortStoryDataSource {
  Future<List<ShortStory?>> getShortStories();

  Future<ShortStory> getShortStory();

  Future<ShortStory?> bookmarkShortStory({required ShortStory story});

  Future<List<ShortStory?>> getBookmarkedStories();
}
