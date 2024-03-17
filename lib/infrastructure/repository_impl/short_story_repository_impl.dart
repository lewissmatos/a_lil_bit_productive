import 'package:a_lil_bit_productive/domain/datasources/short_story_datasource.dart';
import 'package:a_lil_bit_productive/domain/repository/short_story_repository.dart';

import '../../domain/entities/entities.dart';

class ShortStoryRepositoryImpl extends ShortStoryRepository {
  final ShortStoryDatasource shortStoryDatasource;

  ShortStoryRepositoryImpl({required this.shortStoryDatasource});
  @override
  Future<List<ShortStory?>> getShortStories() async {
    return await shortStoryDatasource.getShortStories();
  }

  @override
  Future<ShortStory> getShortStory() async {
    return await shortStoryDatasource.getShortStory();
  }

  @override
  Future<ShortStory?> bookmarkShortStory({required ShortStory story}) async {
    return await shortStoryDatasource.bookmarkShortStory(story: story);
  }

  @override
  Future<List<ShortStory?>> getBookmarkedStories() async {
    return await shortStoryDatasource.getBookmarkedStories();
  }
}
