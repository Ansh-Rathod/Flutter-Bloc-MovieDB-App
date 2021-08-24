import 'dart:async';

import 'package:moviedb/data/fetch_favorite_repo.dart';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moviedb/models/favorite_list_model.dart';

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
