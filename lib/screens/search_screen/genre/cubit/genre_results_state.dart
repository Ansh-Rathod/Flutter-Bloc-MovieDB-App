part of 'genre_results_cubit.dart';

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

class GenreResultsState {
  final int moviePage;
  final int tvPage;
  final bool moviesFull;
  final bool tvFull;
  final String query;
  final MovieStatus movieStatus;
  final TvStatus tvStatus;
  final List<MovieModel> movies;
  final List<TvModel> shows;
  GenreResultsState({
    required this.moviePage,
    required this.tvPage,
    required this.moviesFull,
    required this.tvFull,
    required this.query,
    required this.movieStatus,
    required this.tvStatus,
    required this.movies,
    required this.shows,
  });
  factory GenreResultsState.initial() => GenreResultsState(
        tvPage: 1,
        tvStatus: TvStatus.initial,
        shows: [],
        moviePage: 1,
        movieStatus: MovieStatus.initial,
        tvFull: false,
        moviesFull: false,
        movies: [],
        query: '',
      );

  GenreResultsState copyWith({
    int? moviePage,
    int? tvPage,
    bool? moviesFull,
    bool? tvFull,
    String? query,
    MovieStatus? movieStatus,
    TvStatus? tvStatus,
    List<MovieModel>? movies,
    List<TvModel>? shows,
  }) {
    return GenreResultsState(
      moviePage: moviePage ?? this.moviePage,
      tvPage: tvPage ?? this.tvPage,
      moviesFull: moviesFull ?? this.moviesFull,
      tvFull: tvFull ?? this.tvFull,
      query: query ?? this.query,
      movieStatus: movieStatus ?? this.movieStatus,
      tvStatus: tvStatus ?? this.tvStatus,
      movies: movies ?? this.movies,
      shows: shows ?? this.shows,
    );
  }
}
