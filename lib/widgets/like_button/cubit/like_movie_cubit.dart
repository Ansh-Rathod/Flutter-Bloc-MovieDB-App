import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb/data/fetch_decvice_info.dart';
import 'package:moviedb/data/fetch_favorite_repo.dart';

part 'like_movie_state.dart';

class LikeMovieCubit extends Cubit<LikeMovieState> {
  LikeMovieCubit() : super(LikeMovieState.initial());

  final deviceRepo = DeviceInfoRepo();
  final favRepo = FavoriteRepo();
  void init(String movieid) async {
    var id = await deviceRepo.deviceDetails();

    await FirebaseFirestore.instance
        .collection('Favorite')
        .doc(id)
        .collection('Favorites')
        .doc(movieid)
        .get()
        .then((value) {
      if (value.exists) {
        emit(state.copyWith(isLikeMovie: true));
      } else {
        emit(state.copyWith(isLikeMovie: false));
      }
    });
  }

  void like({
    required String name,
    required String image,
    required String backdrop,
    required String movieid,
    required String date,
    required double rate,
    required bool isMovie,
  }) async {
    var id = await deviceRepo.deviceDetails();

    if (!state.isLikeMovie) {
      emit(state.copyWith(isLikeMovie: true));

      favRepo.addLike(
        name: name,
        rate: rate,
        image: image,
        movieid: movieid,
        date: date,
        backdrop: backdrop,
        isMovie: isMovie,
        id: id,
      );
    } else {
      emit(state.copyWith(isLikeMovie: false));
      favRepo.removeLike(id, movieid);
    }
  }
}
