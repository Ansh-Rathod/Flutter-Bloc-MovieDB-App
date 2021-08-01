part of 'upcoming_bloc.dart';

abstract class UpcomingMoviesState extends Equatable {
  const UpcomingMoviesState();

  @override
  List<Object> get props => [];
}

class UpcomingMoviesInitial extends UpcomingMoviesState {}

class UpcomingMoviesLoading extends UpcomingMoviesState {}

class UpcomingMoviesError extends UpcomingMoviesState {}

class UpcomingMoviesLoaded extends UpcomingMoviesState {
  final List<TvModel> tvshows;
  final List<MovieModel> movies;
  UpcomingMoviesLoaded({
    required this.tvshows,
    required this.movies,
  });
}
