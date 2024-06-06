import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/presentation/screens/story_detail_screen.dart';
import 'package:bab_stories_app/features/news_feature/presentation/widgets/story_grid_card.dart';
import 'package:flutter/material.dart';

class GridViewList extends StatelessWidget {
  final List<Results> snapshot;

  const GridViewList({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    debugPrint("orientation: $orientation");

    return snapshot.isNotEmpty
        ? GridView.builder(
            itemCount: snapshot.length,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
              // Two items per row
              crossAxisSpacing: 2.0,
              // Spacing between columns
              mainAxisSpacing: 2.0,
              // Spacing between rows
              childAspectRatio: orientation == Orientation.portrait
                  ? 0.7
                  : 1.0, // Item aspect ratio
            ),
            itemBuilder: (context, index) {
              var data = snapshot[index];
              var title = data.title.toString();
              var description = data.abstract.toString();
              var thumbnail = data.multimedia?[0].url.toString();

              return StoryGridCard(
                title: title,
                description: description,
                thumbnail: thumbnail ?? "",
                onPress: () {
                  FocusScope.of(context).unfocus();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoryDetailScreen(
                        results: data,
                      ),
                    ),
                  );
                },
              );
            },
          )
        : const Center(
            child: Text("No results"),
          );
  }
}
