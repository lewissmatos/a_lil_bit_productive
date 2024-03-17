import '../entities/entities.dart';

abstract class ShortStoryDatasource {
  Future<List<ShortStory?>> getShortStories();

  Future<ShortStory> getShortStory();

  Future<ShortStory?> bookmarkShortStory({required ShortStory story});

  Future<List<ShortStory?>> getBookmarkedStories();
}
