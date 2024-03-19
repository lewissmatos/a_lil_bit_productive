import 'package:a_lil_bit_productive/domain/datasources/short_story_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/short_story_repository.dart';

import '../../domain/entities/entities.dart';

class ShortStoryRepositoryImpl extends ShortStoryRepository {
  final ShortStoryDataSource shortStoryDataSource;

  ShortStoryRepositoryImpl({required this.shortStoryDataSource});
  @override
  Future<List<ShortStory?>> getShortStories() async {
    return await shortStoryDataSource.getShortStories();
  }

  @override
  Future<ShortStory> getShortStory() async {
    return await shortStoryDataSource.getShortStory();
  }

  @override
  Future<ShortStory?> bookmarkShortStory({required ShortStory story}) async {
    return await shortStoryDataSource.bookmarkShortStory(story: story);
  }

  @override
  Future<List<ShortStory?>> getBookmarkedStories() async {
    return await shortStoryDataSource.getBookmarkedStories();
  }
}
