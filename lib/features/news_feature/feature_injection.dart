import 'package:bab_stories_app/core/helping_func.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'data/network/api_service.dart';
import 'data/network/network_connectivity.dart';
import 'presentation/providers/NetworkProvider.dart';

final locator = GetIt.instance;

void setupLocator() {
  /// Register your services
  locator.registerLazySingleton<NetworkProvider>(() => NetworkProvider());
  locator.registerLazySingleton<ApiService>(() => ApiService());
  locator.registerLazySingleton<Logger>(() => Logger());
  locator
      .registerLazySingleton<NetworkConnectivity>(() => NetworkConnectivity());
  locator.registerLazySingleton<HelpingFunc>(() => HelpingFunc());
}
