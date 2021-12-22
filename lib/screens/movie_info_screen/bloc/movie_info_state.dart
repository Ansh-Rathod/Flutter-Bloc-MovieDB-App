part of 'movie_info_bloc.dart';

abstract class MovieInfoState extends Equatable {
  const MovieInfoState();

  @override
  List<Object> get props => [];
}

class MovieInfoInitial extends MovieInfoState {}

class MovieInfoLoading extends MovieInfoState {}

class MovieInfoLoaded extends MovieInfoState {
  final MovieInfoModel tmdbData;
  final MovieInfoImdb imdbData;
  final List<MovieModel> similar;
  final List<CastInfo> cast;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;

  const MovieInfoLoaded({
    required this.tmdbData,
    required this.imdbData,
    required this.similar,
    required this.cast,
    required this.backdrops,
    required this.trailers,
  });
}

class MovieInfoError extends MovieInfoState {
  final FetchDataError error;

  const MovieInfoError({
    required this.error,
  });
}
