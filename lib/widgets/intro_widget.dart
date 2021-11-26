import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/animation.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/screens/home_screen/home_screen.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';
import 'package:moviedb/widgets/add_collection/add_collection_button.dart';
import 'package:moviedb/widgets/add_collection/cubit/collection_cubit.dart';
import 'package:moviedb/widgets/star_icon_display.dart';
import 'package:moviedb/widgets/watchlist_button/cubit/watchlist_cubit.dart';
import 'package:moviedb/widgets/watchlist_button/watchl_ist_button.dart';

import '../constants.dart';

class IntroContainer extends StatelessWidget {
  final MovieModel tranding;
  const IntroContainer({
    Key? key,
    required this.tranding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: BlocProvider(
            create: (context) => MovieInfoBloc(),
            child: MovieDetailsScreen(
              id: tranding.id,
              backdrop: tranding.backdrop,
            ),
          ),
          pageTransitionAnimation: PageTransitionAnimation.fade,
          withNavBar: false,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 550,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 550,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(tranding.poster),
                ),
              ),
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  begin: Alignment.bottomCenter,
                  colors: [
                    scaffoldColor,
                    scaffoldColor,
                    scaffoldColor,
                    scaffoldColor.withOpacity(.8),
                    scaffoldColor.withOpacity(.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
                right: 0,
                child: Container(
                  alignment: Alignment.topRight,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.bottomRight,
                      begin: Alignment.topRight,
                      colors: [
                        Colors.black.withOpacity(.5),
                        Colors.black.withOpacity(.4),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "MovieDB",
                          style: heading.copyWith(
                            color: Colors.cyanAccent,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 10.0),
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                context: context,
                                builder: (context) {
                                  return BottomSheet(
                                    builder: (context) => Container(
                                      color: Colors.black,
                                      child: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          SizedBox(height: 10),
                                          Container(
                                            child: Center(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5)),
                                                  height: 5,
                                                  width: 100),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(height: 10),
                                          Container(
                                            child: BlocProvider(
                                              create: (context) =>
                                                  WatchlistCubit()
                                                    ..init(tranding.id),
                                              child: WatchListIcon(
                                                rate: tranding.voteAverage,
                                                date: tranding.releaseDate,
                                                image: tranding.poster,
                                                isMovie: true,
                                                title: tranding.title,
                                                movieid: tranding.id,
                                                likeColor: Colors.cyanAccent,
                                                unLikeColor: Colors.white,
                                                backdrop: tranding.backdrop,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            child: BlocProvider(
                                              create: (context) =>
                                                  CollectionCubit()
                                                    ..init(tranding.id),
                                              child: AddCollectionIcon(
                                                date: tranding.releaseDate,
                                                image: tranding.poster,
                                                isMovie: true,
                                                rate: tranding.voteAverage,
                                                title: tranding.title,
                                                movieid: tranding.id,
                                                likeColor: Colors.cyanAccent,
                                                unLikeColor: Colors.white,
                                                backdrop: tranding.backdrop,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                    onClosing: () {},
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 35.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DelayedDisplay(
                              delay: Duration(microseconds: 700),
                              child: Text(
                                tranding.title,
                                style: heading.copyWith(
                                    color: Colors.white, fontSize: 26),
                              ),
                            ),
                            SizedBox(height: 7),
                            DelayedDisplay(
                              delay: Duration(microseconds: 800),
                              child: Text(
                                tranding.releaseDate,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: normalText.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withOpacity(.8),
                                ),
                              ),
                            ),
                            SizedBox(height: 7),
                            DelayedDisplay(
                              delay: Duration(microseconds: 900),
                              child: Row(
                                children: [
                                  IconTheme(
                                    data: IconThemeData(
                                      color: Colors.cyanAccent,
                                      size: 20,
                                    ),
                                    child: StarDisplay(
                                      value: ((tranding.voteAverage * 5) / 10)
                                          .round(),
                                    ),
                                  ),
                                  Text(
                                    "  " +
                                        tranding.voteAverage.toString() +
                                        "/10",
                                    style: normalText.copyWith(
                                      color: Colors.cyanAccent,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
