import 'package:bab_stories_app/features/news_feature/data/network/api_service.dart';
import 'package:bab_stories_app/features/news_feature/domain/models/TopStoriesResponse.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class NetworkProvider with ChangeNotifier implements ReassembleHandler {
  TopStoriesResponse topStoriesResponse = TopStoriesResponse();
  final _logger = Logger();

  /// Loading = 0 ; 1 = Error; 2 = Success
  num isLoading = 0;

  void setLoading({required num value}) {
    isLoading = value;
    notifyListeners();
  }

  // list = true, grid = false;
  bool _typeOfView = true;

  bool get typeOfView => _typeOfView;

  set typeOfView(bool value) {
    _typeOfView = value;
    notifyListeners();
  }

  var _topName = "technology";

  String get topName => _topName;

  set topName(String value) {
    _topName = value.toLowerCase();
    notifyListeners();
  }

  String searchText = "";

  void updateSearchText({required String value}) {
    searchText = value;
    notifyListeners();
  }

  Future<void> getTopStories({
    required String topName,
  }) async {
    try {
      setLoading(value: 0);
      final response = await ApiService.getStories(topName: topName);
      if (response != null) {
        topStoriesResponse = response;
        _logger.i("getTopStories: ${response.results?.length}");
        setLoading(value: 2);
      } else {
        setLoading(value: 1);
      }
      // return response!;
    } catch (e) {
      setLoading(value: 1);
      _logger.e("getTopStories: $e");
    } finally {
      notifyListeners();
    }
  }

  List<Results> filteredByTitleOrAuthor({
    required List<Results> results,
  }) {
    return results
        .where((element) =>
            element.title!.toLowerCase().contains(searchText) ||
            element.byline!.toLowerCase().contains(searchText))
        .toList();
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
  }
}
