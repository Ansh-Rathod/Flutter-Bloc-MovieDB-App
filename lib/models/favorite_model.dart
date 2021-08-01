import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteWatchListModel {
  final String name;
  final bool isMovie;
  final String posters;
  final String date;
  final double rate;
  final String id;
  final String backdrop;
  FavoriteWatchListModel({
    required this.rate,
    required this.name,
    required this.isMovie,
    required this.posters,
    required this.date,
    required this.id,
    required this.backdrop,
  });
  factory FavoriteWatchListModel.fromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return FavoriteWatchListModel(
      date: doc.data()['date'] ?? '',
      backdrop: doc.data()['backdrop'] ?? '',
      isMovie: doc.data()['isMovie'] ?? '',
      name: doc.data()['name'] ?? '',
      posters: doc.data()['image'] ?? '',
      id: doc.data()['id'] ?? '',
      rate: doc.data()['rate'] ?? 0.0,
    );
  }
}

class FavoriteWatchListModelList {
  final List<FavoriteWatchListModel> list;
  FavoriteWatchListModelList({
    required this.list,
  });
  factory FavoriteWatchListModelList.fromDoc(
      QuerySnapshot<Map<String, dynamic>> doc) {
    return new FavoriteWatchListModelList(
        list: doc.docs
            .map((all) => FavoriteWatchListModel.fromDoc(all))
            .toList());
  }
}
