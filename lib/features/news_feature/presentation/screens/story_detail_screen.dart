import 'package:bab_stories_app/core/helping_func.dart';
import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/feature_injection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StoryDetailScreen extends StatelessWidget {
  final Results results;

  const StoryDetailScreen({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 4,
                ),

                /// Image
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: results.multimedia?.first.url ??
                        "https://static01.nyt.com/images/2024/05/20/multimedia/00ROOSE-anthropic-pbwm/00ROOSE-anthropic-pbwm-superJumbo.jpg",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),

                /// Title
                Text(
                  results.title ?? "",
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),

                /// Description
                Text(
                  results.abstract ?? "",
                  maxLines: 10,
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),

                /// See More
                GestureDetector(
                  onTap: () async {
                    var storyUrl = results.url;

                    if (storyUrl != null) {
                      await locator<HelpingFunc>().openUrl(storyUrl: storyUrl);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text("Story url is not available"),
                          ),
                        ),
                      );
                    }
                  },
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "See more",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.deepPurple,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),

                /// Author
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Author: ${results.byline ?? "Anonymous"}",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 6,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 4,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date: ${results.publishedDate}",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
