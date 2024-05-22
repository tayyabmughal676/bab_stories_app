import 'package:bab_stories_app/main.dart';
import 'package:get_it/get_it.dart';

import 'presentation/providers/NetworkProvider.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register your services
  getIt.registerLazySingleton<NetworkProvider>(() => NetworkProvider());
}
