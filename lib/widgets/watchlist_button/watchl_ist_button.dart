import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/constants.dart';

import 'cubit/watchlist_cubit.dart';

class WatchListIcon extends StatelessWidget {
  final String title;
  final String image;
  final String movieid;
  final String date;
  final String backdrop;
  final double rate;
  final Color likeColor;
  final Color unLikeColor;
  final bool isMovie;
  WatchListIcon({
    Key? key,
    required this.title,
    required this.image,
    required this.movieid,
    required this.date,
    required this.backdrop,
    required this.likeColor,
    required this.unLikeColor,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistCubit, WatchlistState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            BlocProvider.of<WatchlistCubit>(context).addToList(
              name: title,
              image: image,
              movieid: movieid,
              date: date,
              backdrop: backdrop,
              isMovie: isMovie,
              rate: rate,
            );
          },
          child: Container(
            child: ListTile(
              leading: Icon(
                  !state.isWatchlist ? Icons.bookmark_add : Icons.bookmark,
                  color: state.isWatchlist ? likeColor : unLikeColor,
                  size: 35),
              title: Text(
                !state.isWatchlist
                    ? "add to Watch list"
                    : "Added to watch list",
                style: normalText.copyWith(color: unLikeColor),
              ),
            ),
          ),
        );
      },
    );
  }
}
