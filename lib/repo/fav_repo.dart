import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteRepo {
  Future<void> addLike({
    required String name,
    required String image,
    required String movieid,
    required String date,
    required double rate,
    required bool isMovie,
    required String id,
    required String backdrop,
  }) async {
    FirebaseFirestore.instance
        .collection('Favorite')
        .doc(id)
        .collection('Favorites')
        .doc(movieid)
        .set({
      "name": name,
      "image": image,
      "rate": rate,
      "backdrop": backdrop,
      "id": movieid,
      "date": date,
      "isMovie": isMovie,
    });
  }

  Future<void> removeLike(String id, String movieid) async {
    FirebaseFirestore.instance
        .collection('Favorite')
        .doc(id)
        .collection('Favorites')
        .doc(movieid)
        .delete();
  }
}
