import 'package:bab_stories_app/features/news_feature/presentation/screens/bab_stories_screen.dart';
import 'package:bab_stories_app/register_providers/register_multi_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'features/news_feature/feature_injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // load .env file
  await dotenv.load(fileName: ".env");

  // setup locator for get-it
  setupLocator();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft
  ]);

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
