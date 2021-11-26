import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/widgets/add_collection/add_collection_button.dart';
import 'package:moviedb/widgets/add_collection/cubit/collection_cubit.dart';
import 'package:moviedb/widgets/watchlist_button/cubit/watchlist_cubit.dart';
import 'package:moviedb/widgets/watchlist_button/watchl_ist_button.dart';
import 'package:url_launcher/url_launcher.dart';

import '../animation.dart';

class SliverAppBarWithShadow extends StatelessWidget {
  SliverAppBarWithShadow({
    Key? key,
    required this.textColor,
    required this.homepage,
    required this.title,
    required this.color,
    required this.poster,
    required this.id,
    required this.releaseDate,
    required this.isMovie,
    required this.rate,
    required this.image,
  }) : super(key: key);
  final Color textColor;
  final String homepage;
  final String image;
  final String title;
  final double rate;
  final Color color;
  final String poster;
  final String id;
  final String releaseDate;
  final bool isMovie;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        pinned: true,
        forceElevated: true,
        stretch: true,
        brightness:
            textColor == Colors.black ? Brightness.light : Brightness.dark,
        elevation: 0,
        backgroundColor: color,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                          color: color,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                child: Center(
                                  child: Container(
                                      decoration: BoxDecoration(
                                          color: textColor,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 5,
                                      width: 100),
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(height: 10),
                              Container(
                                child: BlocProvider(
                                  create: (context) =>
                                      WatchlistCubit()..init(id),
                                  child: WatchListIcon(
                                    date: releaseDate,
                                    image: poster,
                                    isMovie: isMovie,
                                    title: title,
                                    movieid: id,
                                    likeColor: textColor == Colors.black
                                        ? Colors.cyanAccent
                                        : Colors.amber,
                                    unLikeColor: textColor,
                                    backdrop: image,
                                    rate: rate,
                                  ),
                                ),
                              ),
                              Container(
                                child: BlocProvider(
                                  create: (context) =>
                                      CollectionCubit()..init(id),
                                  child: AddCollectionIcon(
                                    date: releaseDate,
                                    image: poster,
                                    rate: rate,
                                    isMovie: isMovie,
                                    title: title,
                                    movieid: id,
                                    likeColor: textColor == Colors.black
                                        ? Colors.blue
                                        : Colors.amber,
                                    unLikeColor: textColor,
                                    backdrop: image,
                                  ),
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  launch(homepage);
                                },
                                leading: Icon(
                                  Icons.open_in_browser,
                                  size: 35,
                                  color: textColor,
                                ),
                                title: Text(
                                  isMovie
                                      ? "Go to Movie Homepage"
                                      : "Go To show homepage",
                                  style: normalText.copyWith(
                                    color: textColor,
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
                color: textColor,
                size: 30.0,
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: textColor,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        expandedHeight: 300,
        iconTheme: IconThemeData(color: textColor),
        flexibleSpace: FlexibleSpaceBar(
          // stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
          centerTitle: true,
          collapseMode: CollapseMode.pin,
          background: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  begin: Alignment.bottomCenter,
                  colors: [
                    color,
                    color.withOpacity(.5),
                    color.withOpacity(.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Container(
                color: color,
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade600,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        image,
                      ),
                    ),
                  ),
                  foregroundDecoration: BoxDecoration(
                    gradient: LinearGradient(
                      end: Alignment.center,
                      begin: Alignment.bottomCenter,
                      colors: [
                        color.withOpacity(.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              )),
        ));
  }
}
