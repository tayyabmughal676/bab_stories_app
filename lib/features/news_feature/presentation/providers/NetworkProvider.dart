import 'package:bab_stories_app/core/enums.dart';
import 'package:bab_stories_app/features/news_feature/data/network/api_service.dart';
import 'package:bab_stories_app/features/news_feature/domain/models/TopStoriesResponse.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class NetworkProvider with ChangeNotifier implements ReassembleHandler {
  TopStoriesResponse topStoriesResponse = TopStoriesResponse();
  final _logger = Logger();

  // /// Loading = 0 ; 1 = Error; 2 = Success
  LoadingState isLoading = LoadingState.loading;

  void setLoading({
    required LoadingState value,
  }) {
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
      setLoading(value: LoadingState.loading);
      final response = await ApiService.getStories(topName: topName);
      if (response != null) {
        topStoriesResponse = response;
        _logger.i("getTopStories: ${response.results?.length}");
        setLoading(value: LoadingState.success);
      } else {
        setLoading(value: LoadingState.error);
      }
    } catch (e) {
      setLoading(value: LoadingState.error);
      _logger.e("getTopStories: $e");
    } finally {
      notifyListeners();
    }
  }

  /// filter by title or author
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
