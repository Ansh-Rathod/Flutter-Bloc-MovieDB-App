part of 'show_info_bloc.dart';

abstract class ShowInfoState extends Equatable {
  const ShowInfoState();

  @override
  List<Object> get props => [];
}

class ShowInfoInitial extends ShowInfoState {}

class ShowInfoLoading extends ShowInfoState {}

class ShowInfoError extends ShowInfoState {}

class ShowInfoNetworkError extends ShowInfoState {}

class ShowInfoLoaded extends ShowInfoState {
  final TvInfoModel tmdbData;
  final List<TvModel> similar;
  final List<CastInfo> cast;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final Color color;
  final Color textColor;
  ShowInfoLoaded({
    required this.images,
    required this.tmdbData,
    required this.similar,
    required this.cast,
    required this.backdrops,
    required this.trailers,
    required this.color,
    required this.textColor,
  });
}
