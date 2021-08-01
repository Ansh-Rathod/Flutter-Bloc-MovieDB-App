import 'dart:async';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/repo/search_repo.dart';

class GetSearchResultsTv {
  final StreamController<List<TvModel>> controller =
      StreamController<List<TvModel>>();
  final repo = SearchRepo();
  var isfinish = false;
  int page = 1;
  List<TvModel> tvshows = [];
  void addData(String query) async {
    final fetchedTv = await repo.getTvShows(query, page);
    controller.sink.add(fetchedTv.movies);
    tvshows.addAll(fetchedTv.movies);
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedTv = await repo.getTvShows(name, page);
    controller.sink.add(fetchedTv.movies);
    tvshows.addAll(fetchedTv.movies);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
