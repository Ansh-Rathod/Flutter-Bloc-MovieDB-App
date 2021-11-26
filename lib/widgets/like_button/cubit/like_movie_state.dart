part of 'like_movie_cubit.dart';

class LikeMovieState extends Equatable {
  final bool isLikeMovie;
  const LikeMovieState(
    this.isLikeMovie,
  );
  factory LikeMovieState.initial() {
    return LikeMovieState(
      false,
    );
  }
  @override
  List<Object> get props => [isLikeMovie];

  LikeMovieState copyWith({
    bool? isLikeMovie,
  }) {
    return LikeMovieState(
      isLikeMovie ?? this.isLikeMovie,
    );
  }
}
