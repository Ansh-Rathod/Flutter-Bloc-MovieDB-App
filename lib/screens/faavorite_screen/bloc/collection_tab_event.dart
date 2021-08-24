part of 'collection_tab_bloc.dart';

abstract class CollectionTabEvent extends Equatable {
  const CollectionTabEvent();

  @override
  List<Object> get props => [];
}

class LoadCollections extends CollectionTabEvent {}
