import 'dart:async';

import 'package:amd/repo/search_repo.dart';

import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';
import '../../../repo/movies_repo.dart';
import '../../../repo/tv_shows_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final repo = MoviesRepo();
  final tvRepo = TVRepo();
  final searchRepo = SearchRepo();

  final colorRepo = ColorGenrator();
  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadHomePage) {
      try {
        yield HomeLoading();

        final MovieModelList tranding = await repo.getMovies();

        final MovieModelList nowPlaying = await repo.getNowPlayingMovies();
        final MovieModelList topRated = await repo.getTopRatedMovies();
        final TvModelList tvShows = await tvRepo.getTvShows();
        final TvModelList topShows = await tvRepo.getTopRatedTvShows();
        final TvModelList tvpopularShows = await tvRepo.getPopularTvShows();
        final MovieModelList movies = await searchRepo.getUpcomingMovies();

        yield HomeLoaded(
          topShows: topShows.movies,
          tranding: tranding.movies,
          tvShows: tvShows.movies,
          upcoming: movies.movies,
          nowPlaying: nowPlaying.movies,
          topRated: topRated.movies,
          tvpopularShows: tvpopularShows.movies,
        );
      } catch (e) {
        print(e.toString());
        yield HomeError();
      }
    }
  }
}
