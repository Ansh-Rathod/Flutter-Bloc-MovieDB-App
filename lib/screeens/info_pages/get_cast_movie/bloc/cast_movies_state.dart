part of 'cast_movies_bloc.dart';

abstract class CastMoviesState extends Equatable {
  const CastMoviesState();

  @override
  List<Object> get props => [];
}

class CastMoviesInitial extends CastMoviesState {}

class CastMoviesLoaded extends CastMoviesState {
  final CastPersonalInfo info;
  final Color color;
  final SocialMediaInfo socialInfo;
  final Color textColor;
  final List<TvModel> tvShows;
  final List<ImageBackdrop> images;
  final List<MovieModel> movies;
  CastMoviesLoaded({
    required this.info,
    required this.color,
    required this.socialInfo,
    required this.textColor,
    required this.tvShows,
    required this.images,
    required this.movies,
  });
}

class CastMoviesLoading extends CastMoviesState {}

class CastMoviesError extends CastMoviesState {}
