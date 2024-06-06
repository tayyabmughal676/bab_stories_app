import 'package:bab_stories_app/core/helping_func.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'data/data_sources/network_source/api_service.dart';
import '../../core/network_connectivity.dart';
import 'presentation/providers/news_provider.dart';

final locator = GetIt.instance;

void setupLocator() {
  /// Register your services
  locator.registerLazySingleton<NewsProvider>(() => NewsProvider());
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<Logger>(() => Logger());
  locator
      .registerLazySingleton<NetworkConnectivity>(() => NetworkConnectivity());
  locator.registerLazySingleton<HelpingFunc>(() => HelpingFunc());
}
