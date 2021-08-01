import 'dart:async';

import '../../../../models/movie_info_model.dart';
import '../../../../models/movie_model.dart';
import '../../../../repo/movies_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'movies_info_event.dart';
part 'movies_info_state.dart';

class MoviesInfoBloc extends Bloc<MoviesInfoEvent, MoviesInfoState> {
  MoviesInfoBloc() : super(MoviesInfoInitial());
  final repo = MoviesRepo();
  final colorRepo = ColorGenrator();
  @override
  Stream<MoviesInfoState> mapEventToState(
    MoviesInfoEvent event,
  ) async* {
    if (event is LoadMoviesInfo) {
      try {
        yield MoviesInfoLoading();
        print(event.id);
        final MovieInfoModel tmdbdata = await repo.getMovieDataById(event.id);
        final Color color =
            await colorRepo.getImagePalette(NetworkImage(tmdbdata.backdrops));
        final Color textColor = colorRepo.calculateTextColor(color);
        print(color);
        final MovieInfoImdb imdbData =
            await repo.getImdbDataById(tmdbdata.imdbid);
        final trailers = await repo.getMovieTrailerById(event.id);
        final images = await repo.getMovieImagesById(event.id);
        final cast = await repo.getMovieCastById(event.id);
        final similar = await repo.getSimilarMovies(event.id);
        List<ImageBackdrop> allImages = [];
        allImages.addAll(images.backdrops);
        allImages.addAll(images.logos);
        allImages.addAll(images.posters);
        yield MoviesInfoLoaded(
          imdbData: imdbData,
          trailers: trailers.trailers,
          backdrops: images.backdrops,
          tmdbData: tmdbdata,
          cast: cast.castList,
          color: color,
          textColor: textColor,
          similar: similar.movies,
          images: allImages,
        );
      } catch (e) {
        print(e.toString());
        yield MoviesInfoError();
      }
    }
  }
}
