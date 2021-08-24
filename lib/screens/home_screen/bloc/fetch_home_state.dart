part of 'fetch_home_bloc.dart';

@immutable
abstract class FetchHomeState {}

class FetchHomeInitial extends FetchHomeState {}

class FetchHomeLoading extends FetchHomeState {}

class FetchHomeLoaded extends FetchHomeState {
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;
  FetchHomeLoaded({
    required this.tranding,
    required this.topRated,
    required this.tvShows,
    required this.topShows,
    required this.upcoming,
    required this.nowPlaying,
  });
}

class FetchHomeError extends FetchHomeState {
  final FetchDataError error;
  FetchHomeError({
    required this.error,
  });
}
