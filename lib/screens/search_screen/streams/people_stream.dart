import 'dart:async';

import 'package:moviedb/data/fetch_genre_data.dart';

import '../../../models/people_model.dart';

class GetSearchResultsPeople {
  final StreamController<List<PeopleModel>> controller =
      StreamController<List<PeopleModel>>();
  final repo = SearchRepo();
  var isfinish = false;
  int page = 1;
  List<PeopleModel> tvshows = [];
  void addData(String query) async {
    final fetchedTv = await repo.getPeoples(query, page);
    controller.sink.add(fetchedTv.peoples);
    tvshows.addAll(fetchedTv.peoples);
    page++;
  }

  void getNextMovies(String name) async {
    final fetchedTv = await repo.getPeoples(name, page);
    controller.sink.add(fetchedTv.peoples);
    tvshows.addAll(fetchedTv.peoples);

    page++;
  }

  void dispose() {
    controller.close();
  }
}
