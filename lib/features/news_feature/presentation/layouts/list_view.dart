import 'package:bab_stories_app/features/news_feature/domain/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/presentation/screens/story_detail_screen.dart';
import 'package:bab_stories_app/features/news_feature/presentation/widgets/story_list_card.dart';
import 'package:flutter/material.dart';

class ListViewLayout extends StatelessWidget {
  final List<Results> snapshot;

  const ListViewLayout({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return snapshot.isNotEmpty
        ? ListView.builder(
            itemCount: snapshot.length,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            itemBuilder: (context, index) {
              var data = snapshot[index];
              var title = data.title.toString();
              var description = data.abstract.toString();
              var thumbnail = data.multimedia?[0].url.toString();

              return StoryListCard(
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
