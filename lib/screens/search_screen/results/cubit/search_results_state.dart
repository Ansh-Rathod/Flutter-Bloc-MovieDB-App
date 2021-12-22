part of 'search_results_cubit.dart';

enum MovieStatus {
  initial,
  loading,
  loaded,
  adding,
  error,
  allfetched,
}
enum TvStatus {
  initial,
  loading,
  loaded,
  adding,

  allfetched,
  error,
}
enum PeopleStatus {
  initial,
  loading,
  loaded,
  adding,
  error,
  allfetched,
}

class SearchResultsState {
  final int moviePage;
  final int tvPage;
  final int peoplePage;
  final bool moviesFull;
  final bool tvFull;
  final bool peopleFull;
  final String query;
  final MovieStatus movieStatus;
  final PeopleStatus peopleStatus;
  final TvStatus tvStatus;
  final List<MovieModel> movies;
  final List<TvModel> shows;
  final List<PeopleModel> people;
  SearchResultsState({
    required this.moviePage,
    required this.tvPage,
    required this.peoplePage,
    required this.moviesFull,
    required this.tvFull,
    required this.peopleFull,
    required this.query,
    required this.movieStatus,
    required this.peopleStatus,
    required this.tvStatus,
    required this.movies,
    required this.shows,
    required this.people,
  });
  factory SearchResultsState.initial() => SearchResultsState(
        tvPage: 1,
        tvStatus: TvStatus.initial,
        shows: [],
        moviePage: 1,
        movieStatus: MovieStatus.initial,
        tvFull: false,
        moviesFull: false,
        peopleFull: false,
        movies: [],
        people: [],
        peoplePage: 1,
        peopleStatus: PeopleStatus.initial,
        query: '',
      );

  SearchResultsState copyWith({
    int? moviePage,
    int? tvPage,
    int? peoplePage,
    bool? moviesFull,
    bool? tvFull,
    bool? peopleFull,
    String? query,
    MovieStatus? movieStatus,
    PeopleStatus? peopleStatus,
    TvStatus? tvStatus,
    List<MovieModel>? movies,
    List<TvModel>? shows,
    List<PeopleModel>? people,
  }) {
    return SearchResultsState(
      moviePage: moviePage ?? this.moviePage,
      tvPage: tvPage ?? this.tvPage,
      peoplePage: peoplePage ?? this.peoplePage,
      moviesFull: moviesFull ?? this.moviesFull,
      tvFull: tvFull ?? this.tvFull,
      peopleFull: peopleFull ?? this.peopleFull,
      query: query ?? this.query,
      movieStatus: movieStatus ?? this.movieStatus,
      peopleStatus: peopleStatus ?? this.peopleStatus,
      tvStatus: tvStatus ?? this.tvStatus,
      movies: movies ?? this.movies,
      shows: shows ?? this.shows,
      people: people ?? this.people,
    );
  }
}
