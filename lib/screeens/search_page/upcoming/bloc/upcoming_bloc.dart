import 'dart:async';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/repo/search_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
part 'upcoming_event.dart';
part 'upcoming_state.dart';

class UpcomingMoviesBloc
    extends Bloc<UpcomingMoviesEvent, UpcomingMoviesState> {
  UpcomingMoviesBloc() : super(UpcomingMoviesInitial());
  final repo = SearchRepo();

  @override
  Stream<UpcomingMoviesState> mapEventToState(
    UpcomingMoviesEvent event,
  ) async* {
    if (event is LoadUpcomingMovies) {
      try {
        yield UpcomingMoviesLoading();
        final movies = await repo.getUpcomingMovies();
        final show = await repo.getUpcomingTvShows();
        yield UpcomingMoviesLoaded(
          tvshows: show.movies,
          movies: movies.movies,
        );
      } catch (e) {
        yield UpcomingMoviesError();
      }
    }
  }
}
