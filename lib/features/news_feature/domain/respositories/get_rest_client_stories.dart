import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';

abstract class GetRestClientStories {
  Future<TopStoriesResponse?> getTopStories({
    required String topName,
  });
}
