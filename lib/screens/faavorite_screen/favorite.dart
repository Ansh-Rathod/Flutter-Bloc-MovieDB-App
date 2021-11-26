import 'package:flutter/services.dart';
import 'package:moviedb/data/fetch_decvice_info.dart';
import 'package:moviedb/models/favorite_list_model.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
import 'package:moviedb/screens/movie_info_screen/movie_Info_screen.dart';
import 'package:moviedb/screens/tvshow_info_screen/bloc/tv_show_detail_bloc.dart';
import 'package:moviedb/screens/tvshow_info_screen/tvshow_info_screen.dart';
import 'package:moviedb/widgets/no_results_found.dart';
import 'package:moviedb/widgets/star_icon_display.dart';

import '../../constants.dart';
import 'bloc/collection_tab_bloc.dart';
import 'collections.dart';
import 'streams/favorites_stream.dart';
import 'watchlist.dart';
import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

class ActivityTab extends StatefulWidget {
  @override
  _ActivityTabState createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  int currentPage = 0;
  late PageController controller;
  @override
  void initState() {
    controller = PageController(initialPage: currentPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: scaffoldColor,
            elevation: 0,
            leading: Container(),
            leadingWidth: 10,
            brightness: Brightness.dark,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(45),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          currentPage = 0;
                          controller.animateToPage(0,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart);
                        });
                      },
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        decoration: BoxDecoration(
                            color: currentPage == 0
                                ? Colors.cyanAccent
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: currentPage == 0
                                  ? Colors.cyanAccent
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          "Favorites",
                          style: normalText.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                currentPage == 0 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        setState(() {
                          currentPage = 1;
                          controller.animateToPage(1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        decoration: BoxDecoration(
                            color: currentPage == 1
                                ? Colors.cyanAccent
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: currentPage == 1
                                  ? Colors.cyanAccent
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          "watchlist",
                          style: normalText.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                currentPage == 1 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      customBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onTap: () {
                        setState(() {
                          controller.animateToPage(2,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOutQuart);

                          currentPage = 2;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        decoration: BoxDecoration(
                            color: currentPage == 2
                                ? Colors.cyanAccent
                                : Colors.transparent,
                            border: Border.all(
                              width: 1.5,
                              color: currentPage == 2
                                  ? Colors.cyanAccent
                                  : Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(16)),
                        child: Text(
                          "collections",
                          style: normalText.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color:
                                currentPage == 2 ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                "Activity",
                style: heading.copyWith(
                  color: Colors.cyanAccent,
                  fontSize: 22,
                ),
              ),
            ),
          ),
          backgroundColor: scaffoldColor,
          body: PageView(
            controller: controller,
            onPageChanged: (int index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              Favorites(),
              WatchLists(),
              BlocProvider<CollectionTabBloc>(
                create: (context) =>
                    CollectionTabBloc()..add(LoadCollections()),
                child: CollectionsTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final GetFavoritesFromFirebase repo = GetFavoritesFromFirebase();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData();
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies();
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: StreamBuilder<List<FavoriteWatchListModel>>(
              stream: repo.controller.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height - 100,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.cyanAccent,
                      ),
                    ),
                  );
                } else if (snapshot.hasData) {
                  final movies = snapshot.data!;
                  if (repo.movies.isNotEmpty) {
                    return Container(
                      child: Column(
                        children: [
                          ListView(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              if (repo.movies.isNotEmpty)
                                ...repo.movies
                                    .map((movie) => FavoriteMovieContainer(
                                          movie: movie,
                                          isFavorite: true,
                                        ))
                                    .toList()
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (repo.movies.isNotEmpty)
                            if (repo.movies.length > 4)
                              if (!repo.isfinish)
                                Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.black,
                                    color: Colors.cyanAccent,
                                  ),
                                )
                        ],
                      ),
                    );
                  } else {
                    return EmptyFavorites();
                  }
                } else {
                  return Container();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class FavoriteMovieContainer extends StatefulWidget {
  final FavoriteWatchListModel movie;
  final bool isFavorite;
  const FavoriteMovieContainer({
    Key? key,
    required this.movie,
    required this.isFavorite,
  }) : super(key: key);

  @override
  _FavoriteMovieContainerState createState() => _FavoriteMovieContainerState();
}

class _FavoriteMovieContainerState extends State<FavoriteMovieContainer> {
  bool isDeleted = false;

  moveToInfo(BuildContext context) {
    if (widget.movie.isMovie) {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => MovieInfoBloc(),
          child: MovieDetailsScreen(
            id: widget.movie.id,
            backdrop: widget.movie.backdrop,
          ),
        ),
        withNavBar: false,
      );
    } else {
      pushNewScreen(
        context,
        withNavBar: false,
        screen: BlocProvider(
          create: (context) => TvShowDetailBloc(),
          child: TvShowDetailScreen(
            backdrop: widget.movie.backdrop,
            id: widget.movie.id,
          ),
        ),
      );
    }
  }

  final deviceRepo = DeviceInfoRepo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: () {
            moveToInfo(context);
          },
          child: !isDeleted
              ? Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Container(
                          color: Colors.grey.shade900,
                          child: CachedNetworkImage(
                            imageUrl: widget.movie.posters,
                            height: 190,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.movie.name,
                                      style: heading.copyWith(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(widget.movie.date,
                                        style: normalText.copyWith(
                                          color: Colors.white,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        IconTheme(
                                          data: IconThemeData(
                                            color: Colors.cyanAccent,
                                            size: 20,
                                          ),
                                          child: StarDisplay(
                                            value:
                                                ((widget.movie.rate * 5) / 10)
                                                    .round(),
                                          ),
                                        ),
                                        Text(
                                          "  " +
                                              widget.movie.rate.toString() +
                                              "/10",
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
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  deleteFavorite();
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Container()),
    );
  }

  deleteFavorite() async {
    var newid = await deviceRepo.deviceDetails();
    if (widget.isFavorite) {
      FirebaseFirestore.instance
          .collection('Favorite')
          .doc(newid)
          .collection('Favorites')
          .doc(widget.movie.id)
          .delete();
      setState(() {
        isDeleted = true;
      });
    } else {
      FirebaseFirestore.instance
          .collection('Watchlist')
          .doc(newid)
          .collection('WatchLists')
          .doc(widget.movie.id)
          .delete();
      setState(() {
        isDeleted = true;
      });
    }
  }
}
