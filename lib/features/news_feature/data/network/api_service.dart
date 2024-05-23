import 'package:bab_stories_app/features/news_feature/domain/models/TopStoriesResponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'base_url.dart';

class ApiService {
  //Singleton instance
  static final ApiService _apiService = ApiService();

  static ApiService get instance => _apiService;
  static final _logger = Logger();
  static final _dio = Dio();

  // technology
  static Future<TopStoriesResponse?> getStories({
    required String topName,
  }) async {
    try {
      var apiKey = dotenv.env['APIKEY'];
      _logger.i("apiKey:$apiKey");
      var resultUrl = '${BaseUrl.baseUrl}/$topName.json?api-key=$apiKey';
      _logger.i("resultUrl: $resultUrl");
      final response = await _dio.request(
        resultUrl,
        options: Options(
          method: "GET",
        ),
      );

      if (response.statusCode == 429) {
        _logger.e("Error: Failed to load top stories");
      }

      TopStoriesResponse parseJson = TopStoriesResponse.fromJson(response.data);
      _logger.i("response: ${parseJson.toJson()}");

      return parseJson;
    } on DioException catch (e) {
      _logger.e("DioExceptionError: $e");
      return null;
    }
  }
}
