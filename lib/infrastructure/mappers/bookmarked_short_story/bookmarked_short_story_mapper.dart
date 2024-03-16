import 'package:a_lil_bit_productive/domain/entities/short_story.dart';
import 'package:a_lil_bit_productive/infrastructure/models/short_stories_api/short_stories_response_model.dart';

class ShortStoryMapper {
  static ShortStory shortStoriesResponseModelToBookmarkedShortStory(
      ShortStoriesResponseModel shortStoriesResponseModel) {
    return ShortStory(
      storyId: shortStoriesResponseModel.id,
      title: shortStoriesResponseModel.title,
      description: shortStoriesResponseModel.story,
      moral: shortStoriesResponseModel.moral,
      author: shortStoriesResponseModel.author,
    );
  }
}
