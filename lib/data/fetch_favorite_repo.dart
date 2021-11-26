import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviedb/models/favorite_list_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'fetch_decvice_info.dart';

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

class LoadUserCollections {
  final deviceRepo = DeviceInfoRepo();
  var id = '';

  Future<List> getFavorite(DocumentSnapshot? dc) async {
    var newid = await deviceRepo.deviceDetails();
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('Favorite')
          .doc(newid)
          .collection('Favorites')
          .limit(10)
          .get();
      id = newid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('Favorite')
          .doc(newid)
          .collection('Favorites')
          .startAfterDocument(dc)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<List> getWatchList(DocumentSnapshot? dc) async {
    var newid = await deviceRepo.deviceDetails();
    if (dc == null) {
      final doc = await FirebaseFirestore.instance
          .collection('Watchlist')
          .doc(newid)
          .collection('WatchLists')
          .limit(10)
          .get();
      id = newid;
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.isNotEmpty ? doc.docs[doc.docs.length - 1] : null
      ];
    } else {
      final doc = await FirebaseFirestore.instance
          .collection('Watchlist')
          .doc(newid)
          .collection('WatchLists')
          .startAfterDocument(dc)
          .limit(10)
          .get();
      return [
        FavoriteWatchListModelList.fromDoc(doc),
        doc.docs.length != 0 ? doc.docs[doc.docs.length - 1] : null
      ];
    }
  }

  Future<CollectionList> getCollectionList() async {
    var newid = await deviceRepo.deviceDetails();

    final docs = await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(newid)
        .collection('CollectionInfo')
        .get();

    return CollectionList.fromDoc(docs);
  }
}
