import 'dart:async';

import 'package:amd/models/favorite_model.dart';
import 'package:amd/models/movie_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/repo/genre_repo.dart';
import 'package:amd/repo/load_favorite_repo.dart';
import 'package:amd/repo/search_repo.dart';

class GetFavoritesFromFirebase {
  final StreamController<List<FavoriteWatchListModel>> controller =
      StreamController<List<FavoriteWatchListModel>>();
  final repo = LoadUserCollections();

  var isfinish = false;
  var lastRepo;
  List<FavoriteWatchListModel> movies = [];
  void addData() async {
    final favorites = await repo.getFavorite(null);
    final List<FavoriteWatchListModel> fetchedMovies = favorites[0].list;
    controller.sink.add(fetchedMovies);
    movies.addAll(fetchedMovies);
    lastRepo = favorites[1];
  }

  void getNextMovies() async {
    final favorites = await repo.getFavorite(lastRepo);
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
