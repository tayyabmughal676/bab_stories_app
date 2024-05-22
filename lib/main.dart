import 'package:bab_stories_app/register_providers/register_multi_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'providers/NetworkProvider.dart';
import 'screens/bab_stories_screen.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register your services
  getIt.registerLazySingleton<NetworkProvider>(() => NetworkProvider());
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load .env file
  await dotenv.load(fileName: ".env");

  // setup locator for get-it
  setupLocator();
  runApp(
    MultiProvider(
      providers: providers,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bab Stories',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BabStoriesScreen(),
    );
  }
}
