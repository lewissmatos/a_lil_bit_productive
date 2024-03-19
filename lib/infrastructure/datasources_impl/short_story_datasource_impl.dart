import 'package:a_lil_bit_productive/domain/datasources/short_story_datasource.dart';
import 'package:a_lil_bit_productive/infrastructure/mappers/bookmarked_short_story/bookmarked_short_story_mapper.dart';
import 'package:a_lil_bit_productive/infrastructure/models/short_stories_api/short_stories_response_model.dart';
import 'package:dio/dio.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/entities/entities.dart';

class ShortStoryDataSourceImpl extends ShortStoryDataSource {
  final dio =
      Dio(BaseOptions(baseUrl: 'https://shortstories-api.onrender.com'));

  late Future<Isar> isarDb;

  ShortStoryDataSourceImpl() {
    isarDb = openIsarDb();
  }

  Future<Isar> openIsarDb() async {
    final dir = await getApplicationDocumentsDirectory();
    if (Isar.instanceNames.isEmpty) {
      return Isar.openSync(
        [
          ReminderSchema,
          NoteSchema,
          ShortStorySchema,
          ExpenseSchema,
        ],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }

  @override
  Future<List<ShortStory?>> getShortStories() async {
    final response = await dio.get('/stories');
    final storiesResponse = List<ShortStoriesResponseModel>.from(
        response.data.map((x) => ShortStoriesResponseModel.fromJson(x)));

    final stories = storiesResponse
        .map((e) =>
            ShortStoryMapper.shortStoriesResponseModelToBookmarkedShortStory(e))
        .toList();

    return stories;
  }

  @override
  Future<ShortStory> getShortStory() async {
    final response = await dio.get('');

    final shortStoriesResponse = ShortStoriesResponseModel.fromJson(
      response.data,
    );

    ShortStory story =
        ShortStoryMapper.shortStoriesResponseModelToBookmarkedShortStory(
      shortStoriesResponse,
    );

    final isar = await isarDb;

    ShortStory? foundStory = await isar.shortStorys
        .filter()
        .storyIdEqualTo(story.storyId)
        .findFirst();

    if (foundStory != null) {
      story.isBookmarked = true;
    }

    return story;
  }

  @override
  Future<ShortStory?> bookmarkShortStory({required ShortStory story}) async {
    final isar = await isarDb;

    ShortStory? foundStory = await isar.shortStorys
        .filter()
        .storyIdEqualTo(story.storyId)
        .findFirst();

    if (foundStory != null) {
      foundStory.isBookmarked = false;
      isar.writeTxn(() async {
        await isar.shortStorys.delete(foundStory.id);
      });
      return foundStory;
    } else {
      story.isBookmarked = true;
      isar.writeTxn(() async {
        await isar.shortStorys.put(story);
      });
      return story;
    }
  }

  @override
  Future<List<ShortStory?>> getBookmarkedStories() async {
    final isar = await isarDb;

    late List<ShortStory?> stories;
    await isar.txn(() async {
      stories = await isar.shortStorys.where().findAll();
    });
    return stories;
  }
}
