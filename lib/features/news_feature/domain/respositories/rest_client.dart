import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part '../../data/data_sources/network_source/rest_client.g.dart';

@RestApi(baseUrl: 'https://api.nytimes.com/svc/topstories/v2/')
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET('/{topName}.json?api-key={apiKey}')
  Future<TopStoriesResponse> getStories(
      @Path('topName') String topName, @Path('apiKey') String apiKey);
}
