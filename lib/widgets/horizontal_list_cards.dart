import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';
import 'package:moviedb/screens/tvshow_info_screen/bloc/tv_show_detail_bloc.dart';
import 'package:moviedb/screens/tvshow_info_screen/tvshow_info_screen.dart';
import 'package:moviedb/widgets/movie_card.dart';

class HorizontalListViewMovies extends StatelessWidget {
  final List<MovieModel> list;
  final Color? color;
  const HorizontalListViewMovies({
    Key? key,
    required this.list,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 310,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 7),
            for (var i = 0; i < list.length; i++)
              MovieCard(
                isMovie: true,
                id: list[i].id,
                name: list[i].title,
                backdrop: list[i].backdrop,
                poster: list[i].poster,
                color: color == null ? Colors.white : color!,
                date: list[i].releaseDate,
                onTap: () {
                  pushNewScreen(
                    context,
                    screen: BlocProvider(
                      create: (context) => MovieInfoBloc(),
                      child: MovieDetailsScreen(
                        id: list[i].id,
                        backdrop: list[i].backdrop,
                      ),
                    ),
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    withNavBar: false,
                  );
                },
              )
          ],
        ));
  }
}

class HorizontalListViewTv extends StatelessWidget {
  final List<TvModel> list;
  final Color? color;

  const HorizontalListViewTv({
    Key? key,
    required this.list,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 310,
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            SizedBox(width: 7),
            for (var i = 0; i < list.length; i++)
              MovieCard(
                isMovie: true,
                id: list[i].id,
                name: list[i].title,
                backdrop: list[i].backdrop,
                poster: list[i].poster,
                color: color == null ? Colors.white : color!,
                date: list[i].releaseDate,
                onTap: () {
                  pushNewScreen(
                    context,
                    pageTransitionAnimation: PageTransitionAnimation.fade,
                    withNavBar: false,
                    screen: BlocProvider(
                      create: (context) => TvShowDetailBloc(),
                      child: TvShowDetailScreen(
                        backdrop: list[i].backdrop,
                        id: list[i].id,
                      ),
                    ),
                  );
                },
              )
          ],
        ));
  }
}
