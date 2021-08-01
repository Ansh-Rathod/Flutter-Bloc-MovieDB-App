part of 'upcoming_bloc.dart';

abstract class UpcomingMoviesEvent extends Equatable {
  const UpcomingMoviesEvent();

  @override
  List<Object> get props => [];
}

class LoadUpcomingMovies extends UpcomingMoviesEvent {}
