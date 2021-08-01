part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<TvModel> tvpopularShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;
  HomeLoaded({
    required this.topRated,
    required this.topShows,
    required this.nowPlaying,
    required this.tvpopularShows,
    required this.upcoming,
    required this.tranding,
    required this.tvShows,
  });
}

class HomeLoading extends HomeState {}

class HomeNetworkError extends HomeState {}

class HomeError extends HomeState {}
