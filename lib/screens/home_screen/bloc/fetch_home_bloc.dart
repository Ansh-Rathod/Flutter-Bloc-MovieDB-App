import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/fetch_home_screen_data.dart';
import '../../../models/error_model.dart';
import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';

part 'fetch_home_event.dart';
part 'fetch_home_state.dart';

class FetchHomeBloc extends Bloc<FetchHomeEvent, FetchHomeState> {
  final FetchHomeRepo repo = FetchHomeRepo();

  FetchHomeBloc() : super(FetchHomeInitial()) {
    on<FetchHomeEvent>((event, emit) async {
      if (event is FetchHomeData) {
        emit(FetchHomeLoading());
        try {
          final data = await repo.getHomePageMovies();
          emit(FetchHomeLoaded(
            topShows: data[4],
            tranding: data[0],
            tvShows: data[5],
            upcoming: data[3],
            nowPlaying: data[1],
            topRated: data[2],
          ));
        } on FetchDataError catch (e) {
          emit(FetchHomeError(error: e));
        } catch (e) {
          emit(FetchHomeError(error: FetchDataError('something went wrong')));
        }
      }
    });
  }
}
