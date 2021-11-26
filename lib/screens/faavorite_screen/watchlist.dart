import 'package:moviedb/models/favorite_list_model.dart';
import 'package:moviedb/widgets/no_results_found.dart';

import 'favorite.dart';
import 'streams/watchlist_stream.dart';
import 'package:flutter/material.dart';

class WatchLists extends StatefulWidget {
  @override
  _WatchListsState createState() => _WatchListsState();
}

class _WatchListsState extends State<WatchLists> {
  final GetWatchListFromFirebase repo = GetWatchListFromFirebase();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies();
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<FavoriteWatchListModel>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!;
                  if (repo.movies.isNotEmpty) {
                    return Container(
                      child: Column(
                        children: [
                          ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (repo.movies.isNotEmpty)
                                ...repo.movies
                                    .map((movie) => FavoriteMovieContainer(
                                          movie: movie,
                                          isFavorite: false,
                                        ))
                                    .toList()
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (repo.movies.isNotEmpty)
                            if (repo.movies.length > 4)
                              if (!repo.isfinish)
                                Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                    color: Colors.cyanAccent,
                                  ),
                                )
                        ],
                      ),
                    );
                  } else {
                    return WatchListFavorites();
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
