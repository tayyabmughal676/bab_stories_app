import 'package:bab_stories_app/core/enums.dart';
import 'package:bab_stories_app/core/network_connectivity.dart';
import 'package:bab_stories_app/features/news_feature/data/models/TopStoriesResponse.dart';
import 'package:bab_stories_app/features/news_feature/feature_injection.dart';
import 'package:bab_stories_app/features/news_feature/presentation/layouts/grid_view_list.dart';
import 'package:bab_stories_app/features/news_feature/presentation/layouts/list_view.dart';
import 'package:bab_stories_app/features/news_feature/presentation/providers/news_provider.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class BabStoriesScreen extends StatefulWidget {
  const BabStoriesScreen({super.key});

  @override
  State<BabStoriesScreen> createState() => _BabStoriesScreenState();
}

class _BabStoriesScreenState extends State<BabStoriesScreen> {
  // get it story provider service
  late NewsProvider networkProvider;

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

  @override
  void initState() {
    // TODO: implement initState

    networkProvider = NewsProvider();
    networkProvider = Provider.of<NewsProvider>(context, listen: false);

    /// initialize connectivity
    locator<NetworkConnectivity>().initConnectivity(context: context);
    locator<NetworkConnectivity>().connectivitySubscription =
        locator<NetworkConnectivity>()
            .connectivity
            .onConnectivityChanged
            .listen((value) {
      locator<NetworkConnectivity>().updateConnectionStatus(
        result: value,
        context: context,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      /// make network call
      networkProvider.getTopStories(topName: networkProvider.topName);
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
    //Direct Provider
    Provider.of<NewsProvider>(context, listen: true);

    // Git-It Locator
    // var getItNetworkProvider = locator<NetworkProvider>();

    /// add Listener for search
    searchController.addListener(() {
      networkProvider.updateSearchText(
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
          child: RefreshIndicator(
            onRefresh: () async {
              await networkProvider.getTopStories(
                topName: networkProvider.topName,
              );
            },
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
                            onChanged: (value) {
                              networkProvider.updateSearchText(
                                value: value,
                              );
                            },
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
                            networkProvider.topName = value;

                            /// load section stories
                            await networkProvider.getTopStories(
                              topName: networkProvider.topName,
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();

                            networkProvider.typeOfView =
                                !networkProvider.typeOfView;
                          },
                          icon: Icon(
                            networkProvider.typeOfView
                                ? Icons.view_list_sharp
                                : Icons.grid_view_sharp,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    /// check network loading state
                    networkProvider.isLoading == LoadingState.success
                        ?

                        ///List view of stories
                        networkProvider.typeOfView
                            ? _buildListView(
                                snapshot:
                                    networkProvider.topStoriesResponse.results!,
                              )
                            : _buildGridViewList(
                                snapshot:
                                    networkProvider.topStoriesResponse.results!,
                              )
                        : networkProvider.isLoading == LoadingState.error
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

  /// Build List View
  Widget _buildListView({
    required List<Results> snapshot,
  }) {
    final searchResult =
        networkProvider.filteredByTitleOrAuthor(results: snapshot);
    locator<Logger>().i("Filtered Result: $searchResult");

    return networkProvider.searchText.isEmpty
        ? ListViewLayout(snapshot: snapshot)
        : ListViewLayout(snapshot: searchResult);
  }

  /// Build Grid View List
  Widget _buildGridViewList({
    required List<Results> snapshot,
  }) {
    final searchResult =
        networkProvider.filteredByTitleOrAuthor(results: snapshot);
    locator<Logger>().i("Filtered Result: $searchResult");

    return networkProvider.searchText.isEmpty
        ? GridViewList(snapshot: snapshot)
        : GridViewList(snapshot: searchResult);
  }
}
