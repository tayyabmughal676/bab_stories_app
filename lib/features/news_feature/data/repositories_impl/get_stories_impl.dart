import 'package:bab_stories_app/features/news_feature/data/data_sources/network_source/api_service.dart';
import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/domain/respositories/get_rest_client_stories.dart';

class GetStoriesImpl implements GetRestClientStories {
  @override
  Future<TopStoriesResponse?> getTopStories({
    required String topName,
  }) {
    try {
      final response =
          ApiService.instance.getRestClientStories(topName: topName);
      return response;
    } catch (e) {
      return e as Future<TopStoriesResponse?>;
    }
  }
}
