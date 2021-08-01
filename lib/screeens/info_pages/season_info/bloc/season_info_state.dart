part of 'season_info_bloc.dart';

abstract class SeasonInfoState extends Equatable {
  const SeasonInfoState();

  @override
  List<Object> get props => [];
}

class SeasonInfoInitial extends SeasonInfoState {}

class SeasonInfoLoaded extends SeasonInfoState {
  final SeasonModel seasonInfo;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> cast;
  final Color color;
  final Color textColor;
  SeasonInfoLoaded({
    required this.seasonInfo,
    required this.backdrops,
    required this.trailers,
    required this.cast,
    required this.color,
    required this.textColor,
  });
}

class SeasonInfoLoading extends SeasonInfoState {}

class SeasonInfoLoadError extends SeasonInfoState {}

class SeasonInfoNetworkError extends SeasonInfoState {}
