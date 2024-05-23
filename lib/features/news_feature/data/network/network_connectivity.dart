import 'dart:async';

import 'package:bab_stories_app/features/news_feature/feature_injection.dart';
import 'package:bab_stories_app/features/news_feature/presentation/providers/NetworkProvider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:open_settings/open_settings.dart';

class NetworkConnectivity with ChangeNotifier {
  List<ConnectivityResult> connectionStatus = [ConnectivityResult.none];
  final Connectivity connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> connectivitySubscription;

  Future<void> initConnectivity({
    required BuildContext context,
  }) async {
    late List<ConnectivityResult> result;
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      locator<Logger>().e('Couldn\'t check connectivity status: $e');
      return;
    } finally {
      notifyListeners();
    }
    return updateConnectionStatus(result: result, context: context);
  }

  Future<void> updateConnectionStatus({
    required List<ConnectivityResult> result,
    required BuildContext context,
  }) async {
    connectionStatus = result;
    if (connectionStatus[0] == ConnectivityResult.none) {
      _showNoConnectionDialog(context: context);
    }
    locator<Logger>().i('Connectivity changed: $connectionStatus');

    /// Make API call when the connection status changes
    await locator<NetworkProvider>()
        .getTopStories(topName: locator<NetworkProvider>().topName);
    notifyListeners();
  }

  /// show no connection dialog
  void _showNoConnectionDialog({
    required BuildContext context,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No Internet Connection'),
          content: const Text('Please check your internet connection.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Open Setting'),
              onPressed: () async {
                await OpenSettings.openWIFISetting();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    connectivitySubscription.cancel();
    super.dispose();
  }
}
