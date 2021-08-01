part of 'watchlist_cubit.dart';

class WatchlistState extends Equatable {
  final bool isWatchlist;
  const WatchlistState(
    this.isWatchlist,
  );
  factory WatchlistState.initial() {
    return WatchlistState(
      false,
    );
  }
  @override
  List<Object> get props => [isWatchlist];

  WatchlistState copyWith({
    bool? isWatchlist,
  }) {
    return WatchlistState(
      isWatchlist ?? this.isWatchlist,
    );
  }
}
