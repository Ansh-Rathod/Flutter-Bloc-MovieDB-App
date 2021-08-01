part of 'movies_info_bloc.dart';

abstract class MoviesInfoState extends Equatable {
  const MoviesInfoState();

  @override
  List<Object> get props => [];
}

class MoviesInfoInitial extends MoviesInfoState {}

class MoviesInfoLoading extends MoviesInfoState {}

class MoviesInfoNetworkError extends MoviesInfoState {}

class MoviesInfoError extends MoviesInfoState {}

class MoviesInfoLoaded extends MoviesInfoState {
  final MovieInfoModel tmdbData;
  final MovieInfoImdb imdbData;
  final List<MovieModel> similar;
  final List<CastInfo> cast;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final Color color;
  final Color textColor;
  final List<ImageBackdrop> images;
  MoviesInfoLoaded({
    required this.images,
    required this.tmdbData,
    required this.imdbData,
    required this.similar,
    required this.cast,
    required this.backdrops,
    required this.trailers,
    required this.color,
    required this.textColor,
  });
}
