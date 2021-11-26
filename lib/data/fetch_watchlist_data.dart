import 'package:cloud_firestore/cloud_firestore.dart';

class WatchListRepo {
  Future<void> addToWatchList({
    required String name,
    required String image,
    required String movieid,
    required String date,
    required double rate,
    required String backdrop,
    required bool isMovie,
    required String id,
  }) async {
    FirebaseFirestore.instance
        .collection('Watchlist')
        .doc(id)
        .collection('WatchLists')
        .doc(movieid)
        .set({
      "name": name,
      "rate": rate,
      "image": image,
      "id": movieid,
      "backdrop": backdrop,
      "date": date,
      "isMovie": isMovie,
    });
  }

  Future<void> removeToWatchList(String id, String movieid) async {
    FirebaseFirestore.instance
        .collection('Watchlist')
        .doc(id)
        .collection('WatchLists')
        .doc(movieid)
        .delete();
  }
}
