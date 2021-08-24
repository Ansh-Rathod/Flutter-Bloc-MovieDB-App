part of 'collection_cubit.dart';

class CollectionState extends Equatable {
  final bool isCollection;
  final String collectionname;
  const CollectionState(
    this.isCollection,
    this.collectionname,
  );
  factory CollectionState.initial() {
    return CollectionState(false, '');
  }
  @override
  List<Object> get props => [isCollection, collectionname];

  CollectionState copyWith({
    bool? isCollection,
    String? collectionname,
  }) {
    return CollectionState(
      isCollection ?? this.isCollection,
      collectionname ?? this.collectionname,
    );
  }
}
