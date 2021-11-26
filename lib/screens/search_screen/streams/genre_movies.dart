import 'dart:async';

import 'package:moviedb/data/fetch_genre_data.dart';

import '../../../models/movie_model.dart';

class GenreMovies {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();
  final repo = GenreRepo();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];
  void addData(String query) async {
    final fetchedmovies = await repo.getMovies(query, page);

    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);
    if (repo.movieResultsCount == movies.length) {
      isfinish = true;
    }
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedmovies = await repo.getMovies(name, page);
    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);
    if (repo.movieResultsCount == movies.length) {
      isfinish = true;
    }
    page++;
  }

  void dispose() {
    controller.close();
  }
}
