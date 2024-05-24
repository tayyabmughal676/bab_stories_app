// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility in the flutter_test package. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.
//
import 'package:bab_stories_app/features/news_feature/data/network/network_connectivity.dart';
import 'package:bab_stories_app/features/news_feature/presentation/providers/NetworkProvider.dart';
import 'package:bab_stories_app/features/news_feature/presentation/screens/bab_stories_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// Mock classes for dependencies
class MockNetworkConnectivity extends Mock implements NetworkConnectivity {}

class MockNetworkProvider extends Mock implements NetworkProvider {}

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    // Register dependencies
    getIt.registerLazySingleton<NetworkConnectivity>(
        () => MockNetworkConnectivity());
    getIt.registerLazySingleton<NetworkProvider>(() => MockNetworkProvider());
    getIt.registerLazySingleton<Logger>(() => Logger());
  });

  tearDown(() {
    getIt.reset();
  });

  testWidgets("Network API Call Test", (WidgetTester tester) async {
    final mockNetworkProvider = getIt<NetworkProvider>() as MockNetworkProvider;

    var anyNamed = "technology";
    // Mock the network call behavior
    when(mockNetworkProvider.getTopStories(topName: anyNamed))
        .thenAnswer((_) async {}); // Provide a behavior for the method

    await tester.pumpWidget(
      ChangeNotifierProvider<NetworkProvider>.value(
        value: mockNetworkProvider,
        child: const MaterialApp(
          home: BabStoriesScreen(),
        ),
      ),
    );

    // Replace 'technology' with the desired non-null value
    verify(mockNetworkProvider.getTopStories(topName: anyNamed)).called(1);
  });
}
