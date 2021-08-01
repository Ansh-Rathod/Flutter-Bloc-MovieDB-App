import 'dart:async';

import 'package:amd/models/collections_model.dart';
import 'package:amd/repo/load_favorite_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'collection_tab_event.dart';
part 'collection_tab_state.dart';

class CollectionTabBloc extends Bloc<CollectionTabEvent, CollectionTabState> {
  CollectionTabBloc() : super(CollectionTabInitial());
  final repo = LoadUserCollections();

  @override
  Stream<CollectionTabState> mapEventToState(
    CollectionTabEvent event,
  ) async* {
    if (event is LoadCollections) {
      try {
        yield CollectionTabLoading();
        final lists = await repo.getCollectionList();
        yield CollectionTabLoaded(collections: lists.list);
      } catch (e) {
        yield CollectionTabError();
      }
    }
  }
}
