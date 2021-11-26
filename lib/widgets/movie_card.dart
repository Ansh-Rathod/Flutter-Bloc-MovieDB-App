import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/constants.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';
import 'package:moviedb/screens/tvshow_info_screen/bloc/tv_show_detail_bloc.dart';
import 'package:moviedb/screens/tvshow_info_screen/tvshow_info_screen.dart';
import 'package:moviedb/widgets/star_icon_display.dart';

class MovieCard extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;
  final VoidCallback onTap;
  final bool isMovie;
  const MovieCard({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.onTap,
    required this.isMovie,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 280),
          child: Column(
            children: [
              Container(
                height: 200,
                width: 130,
                color: Colors.grey.shade900,
                child: CachedNetworkImage(
                  imageUrl: poster,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: 130,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: color.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalMovieCard extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final double rate;
  final String id;
  final Color color;
  final bool isMovie;
  const HorizontalMovieCard({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (isMovie) {
            pushNewScreen(
              context,
              screen: BlocProvider(
                create: (context) => MovieInfoBloc(),
                child: MovieDetailsScreen(
                  id: id,
                  backdrop: backdrop,
                ),
              ),
              pageTransitionAnimation: PageTransitionAnimation.fade,
              withNavBar: false,
            );
          } else {
            pushNewScreen(
              context,
              pageTransitionAnimation: PageTransitionAnimation.fade,
              withNavBar: false,
              screen: BlocProvider(
                create: (context) => TvShowDetailBloc(),
                child: TvShowDetailScreen(
                  backdrop: backdrop,
                  id: id,
                ),
              ),
            );
          }
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  height: 160,
                  width: 130,
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: poster,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: normalText.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          date,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: normalText.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: color.withOpacity(.8),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            IconTheme(
                              data: IconThemeData(
                                color: Colors.cyanAccent,
                                size: 20,
                              ),
                              child: StarDisplay(
                                value: ((rate * 5) / 10).round(),
                              ),
                            ),
                            Text(
                              "  " + rate.toString() + "/10",
                              style: normalText.copyWith(
                                color: Colors.cyanAccent,
                                letterSpacing: 1.2,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
