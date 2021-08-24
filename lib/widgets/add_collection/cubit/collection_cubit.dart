import 'package:moviedb/data/fetch_decvice_info.dart';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'collection_state.dart';

class CollectionCubit extends Cubit<CollectionState> {
  CollectionCubit() : super(CollectionState.initial());

  final deviceRepo = DeviceInfoRepo();
  void init(String movieid) async {
    var id = await deviceRepo.deviceDetails();

    await FirebaseFirestore.instance
        .collection('UserCollections')
        .doc(id)
        .collection('allMovies')
        .doc(movieid)
        .get()
        .then((value) {
      if (value.exists) {
        emit(
          state.copyWith(
            isCollection: true,
            collectionname: value.data()!['inCollection'],
          ),
        );
      } else {
        emit(state.copyWith(isCollection: false));
      }
    });
  }
}
