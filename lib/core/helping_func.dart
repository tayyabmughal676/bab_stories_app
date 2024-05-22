import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpingFunc {
  static Future<void> openUrl({
    required String storyUrl,
  }) async {
    final Uri url = Uri.parse(storyUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $url");
      throw Exception('Could not launch $url');
    }
  }
}
