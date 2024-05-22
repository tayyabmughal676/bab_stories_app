import 'package:bab_stories_app/network/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/providers/NetworkProvider.dart';
import 'package:bab_stories_app/widgets/story_grid_card.dart';
import 'package:bab_stories_app/widgets/story_list_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'story_detail_screen.dart';

class BabStoriesScreen extends StatefulWidget {
  const BabStoriesScreen({super.key});

  @override
  State<BabStoriesScreen> createState() => _BabStoriesScreenState();
}

class _BabStoriesScreenState extends State<BabStoriesScreen> {
  // search controller
  final searchController = TextEditingController();
  final List<String> _sections = [
    'World',
    'US',
    'Politics',
    'Business',
    'Technology',
    'Health',
    'Sports',
    'Arts',
    'Books',
    'Style',
    'Food',
    'Travel',
    'Magazine',
    'Opinion',
  ];

  final String _selectedSection = "technology".toLowerCase();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<NetworkProvider>()
          .getTopStories(topName: context.read<NetworkProvider>().topName);
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    searchController.addListener(() {
      context.read<NetworkProvider>().updateSearchText(
            value: searchController.text.toString().trim().toLowerCase(),
          );
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 4.0,
        title: const Text(
          "Bab Stories",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),

                    /// Search bar filter, List, Grid
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
                            decoration: const InputDecoration(
                              isDense: true,
                              // Reduces the height
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 6.0,
                                horizontal: 8.0,
                              ),
                              border: OutlineInputBorder(),
                              labelText: 'e.g: Title or Author',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.filter_list_sharp,
                            color: Colors.deepPurple,
                          ),
                          itemBuilder: (BuildContext context) {
                            return _sections.map((String section) {
                              return PopupMenuItem<String>(
                                value: section,
                                child: Text(section),
                              );
                            }).toList();
                          },
                          onSelected: (String value) async {
                            FocusScope.of(context).unfocus();

                            /// set selected section
                            context.read<NetworkProvider>().topName = value;

                            /// load section stories
                            await context.read<NetworkProvider>().getTopStories(
                                  topName:
                                      context.read<NetworkProvider>().topName,
                                );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            context.read<NetworkProvider>().typeOfView =
                                !context.read<NetworkProvider>().typeOfView;
                          },
                          icon: Icon(
                            context.read<NetworkProvider>().typeOfView
                                ? Icons.view_list_sharp
                                : Icons.grid_view_sharp,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    context.read<NetworkProvider>().isLoading == 2
                        ?

                        ///List view of stories
                        context.read<NetworkProvider>().typeOfView
                            ? buildListView(
                                snapshot: context
                                    .read<NetworkProvider>()
                                    .topStoriesResponse
                                    .results!)
                            : buildGridViewList(
                                snapshot: context
                                    .read<NetworkProvider>()
                                    .topStoriesResponse
                                    .results!)
                        : context.read<NetworkProvider>().isLoading == 1
                            ? const Text("Error")
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.deepPurple,
                                ),
                              ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListView({
    required List<Results> snapshot,
  }) {
    final searchResult = context
        .read<NetworkProvider>()
        .filteredByTitleOrAuthor(results: snapshot);
    debugPrint("Filtered Result: $searchResult");

    return context.read<NetworkProvider>().searchText.isEmpty
        ? listView(snapshot: snapshot)
        : listView(snapshot: searchResult);
  }

  Widget buildGridViewList({
    required List<Results> snapshot,
  }) {
    final searchResult = context
        .read<NetworkProvider>()
        .filteredByTitleOrAuthor(results: snapshot);
    debugPrint("Filtered Result: $searchResult");

    return context.read<NetworkProvider>().searchText.isEmpty
        ? gridViewList(snapshot: snapshot)
        : gridViewList(snapshot: searchResult);
  }

  Widget listView({
    required List<Results> snapshot,
  }) {
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

  /// Grid View List
  Widget gridViewList({
    required List<Results> snapshot,
  }) {
    return snapshot.isNotEmpty
        ? GridView.builder(
            itemCount: snapshot.length,
            shrinkWrap: true,
            physics: const PageScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Two items per row
              crossAxisSpacing: 2.0, // Spacing between columns
              mainAxisSpacing: 2.0, // Spacing between rows
              childAspectRatio: 0.7, // Item aspect ratio
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
