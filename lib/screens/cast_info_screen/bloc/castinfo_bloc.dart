import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/fetch_cast_details.dart';
import '../../../models/cast_info_model.dart';
import '../../../models/error_model.dart';
import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';

part 'castinfo_event.dart';
part 'castinfo_state.dart';

class CastinfoBloc extends Bloc<CastinfoEvent, CastinfoState> {
  final FetchCastInfoById repo = FetchCastInfoById();

  CastinfoBloc() : super(CastinfoInitial()) {
    on<CastinfoEvent>((event, emit) async {
      if (event is LoadCastInfo) {
        try {
          emit(CastinfoLoading());
          final data = await repo.getCastDetails(event.id);

          emit(CastinfoLoaded(
            info: data[0],
            movies: data[3],
            socialInfo: data[1],
            images: data[2],
            tvShows: data[4],
          ));
        } on FetchDataError catch (e) {
          emit(CastinfoError(error: e));
        } catch (e) {
          emit(CastinfoError(error: FetchDataError(e.toString())));
        }
      }
    });
  }
}
