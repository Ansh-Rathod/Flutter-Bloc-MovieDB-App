import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/fetch_movie_data_by_id.dart';
import '../../../models/error_model.dart';
import '../../../models/movie_model.dart';

part 'movie_info_event.dart';
part 'movie_info_state.dart';

class MovieInfoBloc extends Bloc<MovieInfoEvent, MovieInfoState> {
  final repo = FetchMovieDataById();

  MovieInfoBloc() : super(MovieInfoInitial()) {
    on<MovieInfoEvent>((event, emit) async {
      if (event is LoadMoviesInfo) {
        try {
          emit(MovieInfoLoading());
          final List<dynamic> info = await repo.getDetails(event.id);
          emit(MovieInfoLoaded(
            imdbData: info[4],
            trailers: info[1],
            backdrops: info[2],
            tmdbData: info[0],
            cast: info[3],
            similar: info[5],
          ));
        } on FetchDataError catch (e) {
          emit(MovieInfoError(error: e));
        } catch (e) {
          emit(MovieInfoError(error: FetchDataError(e.toString())));
        }
      }
    });
  }
}
