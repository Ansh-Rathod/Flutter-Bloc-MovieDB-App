part of 'castinfo_bloc.dart';

abstract class CastinfoEvent extends Equatable {
  const CastinfoEvent();

  @override
  List<Object> get props => [];
}

class LoadCastInfo extends CastinfoEvent {
  final String id;
  LoadCastInfo({
    required this.id,
  });
}
