part of 'season_detail_bloc.dart';

abstract class SeasonDetailState extends Equatable {
  const SeasonDetailState();

  @override
  List<Object> get props => [];
}

class SeasonDetailInitial extends SeasonDetailState {}

class SeasonDetailLoaded extends SeasonDetailState {
  final SeasonModel seasonDetail;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> cast;

  const SeasonDetailLoaded({
    required this.seasonDetail,
    required this.backdrops,
    required this.trailers,
    required this.cast,
  });
}

class SeasonDetailLoading extends SeasonDetailState {}

class SeasonDetailError extends SeasonDetailState {
  final FetchDataError error;
  const SeasonDetailError({
    required this.error,
  });
}
