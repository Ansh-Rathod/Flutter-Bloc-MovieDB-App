part of 'search_results_bloc.dart';

abstract class SearchResultsState extends Equatable {
  const SearchResultsState();

  @override
  List<Object> get props => [];
}

class SearchResultsInitial extends SearchResultsState {}

class SearchResultsLoaded extends SearchResultsState {
  final List<MovieModel> movies;
  final int moviesCount;
  final int showsCount;
  final int peopleCount;
  final List<PeopleModel> people;
  final List<TvModel> shows;
  final String query;
  SearchResultsLoaded({
    required this.movies,
    required this.moviesCount,
    required this.showsCount,
    required this.peopleCount,
    required this.people,
    required this.shows,
    required this.query,
  });
}

class SearchResultsLoading extends SearchResultsState {}

class SearchResultsError extends SearchResultsState {}
