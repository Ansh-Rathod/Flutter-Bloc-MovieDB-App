import 'dart:async';

import 'package:amd/models/movie_model.dart';
import 'package:amd/repo/search_repo.dart';

class GetSearchResults {
  final StreamController<List<MovieModel>> controller =
      StreamController<List<MovieModel>>();
  final repo = SearchRepo();
  var isfinish = false;
  int page = 1;
  List<MovieModel> movies = [];
  void addData(String query) async {
    final fetchedmovies = await repo.getMovies(query, page);
    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedmovies = await repo.getMovies(name, page);
    controller.sink.add(fetchedmovies.movies);
    movies.addAll(fetchedmovies.movies);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
