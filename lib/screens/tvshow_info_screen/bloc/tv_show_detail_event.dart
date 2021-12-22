part of 'tv_show_detail_bloc.dart';

abstract class TvShowDetailEvent extends Equatable {
  const TvShowDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadTvInfo extends TvShowDetailEvent {
  final String id;
  const LoadTvInfo({
    required this.id,
  });
}
