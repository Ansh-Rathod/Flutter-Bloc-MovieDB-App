import 'package:amd/models/collections_model.dart';
import 'package:amd/models/favorite_model.dart';
import 'package:amd/repo/device_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
