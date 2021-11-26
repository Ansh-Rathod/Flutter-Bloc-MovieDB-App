import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants.dart';
import 'cubit/like_movie_cubit.dart';

class FavirIcon extends StatelessWidget {
  final String title;
  final String image;
  final String movieid;
  final Color likeColor;
  final Color unLikeColor;
  final String date;
  final double rate;
  final bool isMovie;
  final String backdrop;
  const FavirIcon({
    Key? key,
    required this.title,
    required this.image,
    required this.movieid,
    required this.likeColor,
    required this.unLikeColor,
    required this.date,
    required this.isMovie,
    required this.backdrop,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikeMovieCubit, LikeMovieState>(
      builder: (context, state) {
        return RaisedButton(
          elevation: 0,
          color: Colors.grey.withOpacity(.3),
          onPressed: () {
            BlocProvider.of<LikeMovieCubit>(context).like(
              name: title,
              image: image,
              movieid: movieid,
              rate: rate,
              backdrop: backdrop,
              date: date,
              isMovie: isMovie,
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: state.isLikeMovie ? likeColor : unLikeColor,
                size: 30,
              ),
              Text(!state.isLikeMovie ? " Add to Favorite" : " Your Favorite",
                  style: normalText.copyWith(color: unLikeColor))
            ],
          ),
        );
      },
    );
  }
}
