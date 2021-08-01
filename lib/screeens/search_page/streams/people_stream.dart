import 'dart:async';

import 'package:amd/models/people_model.dart';
import 'package:amd/repo/search_repo.dart';

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
