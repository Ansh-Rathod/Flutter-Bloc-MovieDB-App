import 'dart:async';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/people_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/repo/search_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  SearchResultsBloc() : super(SearchResultsInitial());
  final repo = SearchRepo();
  @override
  Stream<SearchResultsState> mapEventToState(
    SearchResultsEvent event,
  ) async* {
    try {
      if (event is LoadSearchResults) {
        yield SearchResultsLoading();
        final movies = await repo.getMovies(event.query, 1);
        final show = await repo.getTvShows(event.query, 1);
        final people = await repo.getPeoples(event.query, 1);
        yield SearchResultsLoaded(
          movies: movies.movies,
          shows: show.movies,
          query: event.query,
          moviesCount: repo.movieResultsCount ?? 0,
          showsCount: repo.showsResultsCount ?? 0,
          people: people.peoples,
          peopleCount: repo.peopleResultsCount ?? 0,
        );
      }
    } catch (e) {
      yield SearchResultsError();
    }
  }
}
