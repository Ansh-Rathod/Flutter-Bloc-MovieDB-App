import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amd/repo/device_repo.dart';
import 'package:amd/screeens/add_collections/add_to_collection.dart';
import 'package:amd/widgets/add_collection/cubit/collection_cubit.dart';

import '../../themes.dart';

class AddCollectionIcon extends StatelessWidget {
  final String title;
  final String image;
  final String movieid;
  final String backdrop;
  final Color likeColor;
  final Color unLikeColor;
  final String date;
  final double rate;
  final bool isMovie;
  AddCollectionIcon({
    Key? key,
    required this.title,
    required this.image,
    required this.movieid,
    required this.backdrop,
    required this.likeColor,
    required this.unLikeColor,
    required this.date,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);
  final DeviceInfoRepo deviceRepo = DeviceInfoRepo();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        return ListTile(
            onTap: () async {
              var devid = await deviceRepo.deviceDetails();

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddToCollection(
                    date: date,
                    image: image,
                    isMovie: isMovie,
                    title: title,
                    rate: rate,
                    movieid: movieid,
                    devid: devid,
                    backdrop: backdrop,
                  ),
                ),
              );
            },
            leading: Icon(
              Icons.list,
              color: state.isCollection ? likeColor : unLikeColor,
              size: 30,
            ),
            title: Text(
              !state.isCollection
                  ? " Add to Collection"
                  : " Already in ${state.collectionname}",
              style: normalText.copyWith(
                color: unLikeColor,
              ),
            ));
      },
    );
  }
}
