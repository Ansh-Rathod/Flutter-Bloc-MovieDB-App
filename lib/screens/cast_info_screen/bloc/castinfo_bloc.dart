import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb/data/fetch_cast_details.dart';
import 'package:moviedb/models/cast_info_model.dart';
import 'package:moviedb/models/error_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';

part 'castinfo_event.dart';
part 'castinfo_state.dart';

class CastinfoBloc extends Bloc<CastinfoEvent, CastinfoState> {
  CastinfoBloc() : super(CastinfoInitial());
  final FetchCastInfoById repo = FetchCastInfoById();
  @override
  Stream<CastinfoState> mapEventToState(
    CastinfoEvent event,
  ) async* {
    if (event is LoadCastInfo) {
      try {
        yield CastinfoLoading();
        final data = await repo.getCastDetails(event.id);

        yield CastinfoLoaded(
          info: data[0],
          movies: data[3],
          socialInfo: data[1],
          images: data[2],
          tvShows: data[4],
        );
      } on FetchDataError catch (e) {
        print(e.toString());
        yield CastinfoError(error: e);
      } catch (e) {
        print(e.toString());
        yield CastinfoError(error: FetchDataError(e.toString()));
      }
    }
  }
}
