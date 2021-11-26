import 'package:moviedb/data/fetch_decvice_info.dart';
import 'package:moviedb/data/fetch_watchlist_data.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  WatchlistCubit() : super(WatchlistState.initial());
  final deviceRepo = DeviceInfoRepo();
  final favRepo = WatchListRepo();
  void init(String movieid) async {
    var id = await deviceRepo.deviceDetails();

    await FirebaseFirestore.instance
        .collection('Watchlist')
        .doc(id)
        .collection('WatchLists')
        .doc(movieid)
        .get()
        .then((value) {
      if (value.exists) {
        emit(state.copyWith(isWatchlist: true));
      } else {
        emit(state.copyWith(isWatchlist: false));
      }
    });
  }

  void addToList({
    required String name,
    required String image,
    required String backdrop,
    required String movieid,
    required String date,
    required double rate,
    required bool isMovie,
  }) async {
    var id = await deviceRepo.deviceDetails();

    if (!state.isWatchlist) {
      emit(state.copyWith(isWatchlist: true));

      favRepo.addToWatchList(
        name: name,
        image: image,
        movieid: movieid,
        date: date,
        isMovie: isMovie,
        id: id,
        rate: rate,
        backdrop: backdrop,
      );
    } else {
      emit(state.copyWith(isWatchlist: false));
      favRepo.removeToWatchList(id, movieid);
    }
  }
}
