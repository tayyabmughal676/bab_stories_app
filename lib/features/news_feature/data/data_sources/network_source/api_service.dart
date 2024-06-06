import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/feature_injection.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import '../../../../../core/base_url.dart';
import '../../../domain/respositories/rest_client.dart';

class ApiService {
  //Singleton instance
  static final ApiService _apiService = ApiService();

  static ApiService get instance => _apiService;
  final _dio = Dio();

  /// Retrofit call, get stories
  Future<TopStoriesResponse?> getRestClientStories({
    required String topName,
  }) async {
    try {
      final client = RestClient(_dio);
      var apiKey = dotenv.env['APIKEY'];
      locator<Logger>().i("apiKey:$apiKey");

      final response = await client.getStories(topName, apiKey!);
      if (response.status == "OK") {
        locator<Logger>()
            .i("response: ${response.status}, ${response.results?.length}");
        locator<Logger>().i("response: ${response.toJson()}");
        return response;
      } else {
        return null;
      }
    } on DioException catch (e) {
      locator<Logger>().e("DioExceptionError: $e");
      return null;
    }
  }

  /// Dio, get stories
  Future<TopStoriesResponse?> getStories({
    required String topName,
  }) async {
    try {
      //
      var apiKey = dotenv.env['APIKEY'];
      locator<Logger>().i("apiKey:$apiKey");
      //
      var resultUrl = '${BaseUrl.baseUrl}/$topName.json?api-key=$apiKey';
      locator<Logger>().i("resultUrl: $resultUrl");

      /// dio get request
      final response = await _dio.request(
        resultUrl,
        options: Options(
          method: "GET",
        ),
      );

      /// if request limit exceeded error
      if (response.statusCode == 429) {
        locator<Logger>().e("Error: Failed to load top stories");
      }

      TopStoriesResponse parseJson = TopStoriesResponse.fromJson(response.data);
      locator<Logger>().i("response: ${parseJson.toJson()}");

      return parseJson;
    } on DioException catch (e) {
      locator<Logger>().e("DioExceptionError: $e");
      return null;
    }
  }
}
