import 'dart:async';

import 'package:moviedb/data/fetch_favorite_repo.dart';
import 'package:moviedb/models/favorite_list_model.dart';

import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';

class GetWatchListFromFirebase {
  final StreamController<List<FavoriteWatchListModel>> controller =
      StreamController<List<FavoriteWatchListModel>>();
  final repo = LoadUserCollections();

  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];
  void addData() async {
    final favorites = await repo.getWatchList(null);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies() async {
    final favorites = await repo.getWatchList(lastRepo);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;

    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    if (favorites[1] == null) {
      isfinish = true;
    } else {
      lastRepo = favorites[1];
    }
  }

  void dispose() {
    controller.close();
  }
}
