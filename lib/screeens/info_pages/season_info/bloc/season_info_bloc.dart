import 'dart:async';

import 'package:amd/models/movie_info_model.dart';
import 'package:amd/models/season_info.dart';
import 'package:amd/repo/movies_repo.dart';
import 'package:amd/repo/season_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'season_info_event.dart';
part 'season_info_state.dart';

class SeasonInfoBloc extends Bloc<SeasonInfoEvent, SeasonInfoState> {
  SeasonInfoBloc() : super(SeasonInfoInitial());
  final repo = SeasonRepo();
  final colorRepo = ColorGenrator();

  @override
  Stream<SeasonInfoState> mapEventToState(
    SeasonInfoEvent event,
  ) async* {
    if (event is LoadSeasonInfo) {
      try {
        yield SeasonInfoLoading();
        final seasonInfo = await repo.getSeasonInfo(event.id, event.snum);
        final Color color = await colorRepo
            .getImagePalette(NetworkImage(seasonInfo.posterPath));
        final Color textColor = colorRepo.calculateTextColor(color);

        final castList = await repo.getseasonCastById(event.id, event.snum);

        final trailers = await repo.getSeasonTrailerById(event.id, event.snum);
        final images = await repo.getSeasonImagesById(event.id, event.snum);
        yield SeasonInfoLoaded(
          cast: castList.castList,
          seasonInfo: seasonInfo,
          trailers: trailers.trailers,
          backdrops: images.backdrops,
          color: color,
          textColor: textColor,
        );
      } catch (e) {
        yield SeasonInfoLoadError();
      }
    }
  }
}
