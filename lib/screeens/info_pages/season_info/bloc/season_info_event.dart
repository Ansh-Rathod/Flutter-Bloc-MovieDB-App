part of 'season_info_bloc.dart';

abstract class SeasonInfoEvent extends Equatable {
  const SeasonInfoEvent();

  @override
  List<Object> get props => [];
}

class LoadSeasonInfo extends SeasonInfoEvent {
  final String id;
  final String snum;
  LoadSeasonInfo({
    required this.id,
    required this.snum,
  });
}
