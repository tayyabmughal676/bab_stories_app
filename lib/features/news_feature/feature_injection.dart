import 'package:bab_stories_app/main.dart';
import 'package:get_it/get_it.dart';

import 'data/network/api_service.dart';
import 'presentation/providers/NetworkProvider.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Register your services
  locator.registerLazySingleton<NetworkProvider>(() => NetworkProvider());
  locator.registerLazySingleton<ApiService>(() => ApiService());
}
