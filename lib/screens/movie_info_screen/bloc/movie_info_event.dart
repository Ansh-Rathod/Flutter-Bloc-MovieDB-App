part of 'movie_info_bloc.dart';

abstract class MovieInfoEvent extends Equatable {
  const MovieInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadMoviesInfo extends MovieInfoEvent {
  final String id;

  LoadMoviesInfo({
    required this.id,
  });
}
