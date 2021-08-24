part of 'collection_tab_bloc.dart';

abstract class CollectionTabState extends Equatable {
  const CollectionTabState();

  @override
  List<Object> get props => [];
}

class CollectionTabInitial extends CollectionTabState {}

class CollectionTabLoaded extends CollectionTabState {
  final List<Collection> collections;

  CollectionTabLoaded({
    required this.collections,
  });
}

class CollectionTabLoading extends CollectionTabState {}

class CollectionTabError extends CollectionTabState {}
