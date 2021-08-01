import 'dart:math';

import 'package:amd/widgets/Error_page.dart';
import 'package:amd/widgets/add_collection/add_collection_button.dart';
import 'package:amd/widgets/add_collection/cubit/collection_cubit.dart';
import 'package:amd/widgets/loading.dart';
import 'package:amd/widgets/watchlist_button/cubit/watchlist_cubit.dart';
import 'package:amd/widgets/watchlist_button/watchl_ist_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bottom_nav_bar/persistent-tab-view.dart';

import 'package:amd/models/movie_model.dart';
import 'package:amd/widgets/star_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../themes.dart';
import '../info_pages/movies_info/bloc/movies_info_bloc.dart';
import '../info_pages/movies_info/movies_info.dart';
import '../info_pages/tv_shows_info/bloc/show_info_bloc.dart';
import '../info_pages/tv_shows_info/tv_show_info.dart';
import 'bloc/home_bloc.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          drawer: Drawer(
              child: Container(
            child: ListView(
              children: [
                SizedBox(height: 20),
                Container(
                  child: CachedNetworkImage(
                      height: 100,
                      imageUrl:
                          'https://media-exp1.licdn.com/dms/image/C4D0BAQEdRMOG3VMr0Q/company-logo_200_200/0/1585407202899?e=1635984000&v=beta&t=1CoAmRySnEeR9mBOT77oJDLUeWWyVzpKq9vNPK-_exo'),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                ListTile(
                  onTap: () {
                    launch(
                        'mailto:anshrathod29@gmail.com?subject=Feedback&body=Hello');
                  },
                  title: Text(
                    'Feedback',
                    style: normalText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.cyanAccent, size: 20),
                ),
                ListTile(
                  onTap: () {
                    launch(
                        'mailto:anshrathod29@gmail.com?subject=Report%20Bug&body=');
                  },
                  title: Text(
                    'Report Bug',
                    style: normalText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.cyanAccent, size: 20),
                ),
                ListTile(
                  onTap: () {
                    launch(
                        'https://github.com/Ansh-Rathod/Flutter-Bloc-TiViBu-App');
                  },
                  title: Text(
                    'Share my app',
                    style: normalText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.cyanAccent, size: 20),
                ),
                ListTile(
                  title: Text(
                    'Open source',
                    style: normalText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Colors.cyanAccent, size: 20),
                ),
              ],
            ),
            color: scaffoldColor,
          )),
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          backgroundColor: scaffoldColor,
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return HomeLoadingPage();
              } else if (state is HomeLoaded) {
                List<MovieModel> newList = [];
                newList.addAll(state.tranding);
                newList..shuffle();
                return SafeArea(
                  child: SingleChildScrollView(
                    physics:
                        BouncingScrollPhysics(parent: BouncingScrollPhysics()),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 550,
                          foregroundDecoration: BoxDecoration(
                            gradient: LinearGradient(
                              end: Alignment.bottomCenter,
                              begin: Alignment.bottomCenter,
                              colors: [
                                scaffoldColor.withOpacity(.5),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: PageView(
                            scrollDirection: Axis.horizontal,
                            dragStartBehavior: DragStartBehavior.start,
                            physics: BouncingScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            children: [
                              for (var i = 0; i < newList.length; i++)
                                Center(
                                  child: IntroContainer(
                                    scaffoldKey: _scaffoldKey,
                                    tranding: newList[i],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text("In Theaters",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 7),
                              for (var i = 0; i < state.tranding.length; i++)
                                MoviePoster(
                                  isMovie: true,
                                  id: state.tranding[i].id,
                                  name: state.tranding[i].title,
                                  backdrop: state.tranding[i].backdrop,
                                  poster: state.tranding[i].poster,
                                  color: Colors.white,
                                  date: state.tranding[i].release_date,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Text("Streaming & Tv",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0; i < state.tvShows.length; i++)
                                MoviePoster(
                                  isMovie: false,
                                  id: state.tvShows[i].id,
                                  name: state.tvShows[i].title,
                                  backdrop: state.tvShows[i].backdrop,
                                  poster: state.tvShows[i].poster,
                                  color: Colors.white,
                                  date: state.tvShows[i].release_date,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text("Top rated movies all time",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0; i < state.topRated.length; i++)
                                BackdropPoster(
                                  isMovie: true,
                                  id: state.topRated[i].id,
                                  name: state.topRated[i].title,
                                  backdrop: state.topRated[i].backdrop,
                                  poster: state.topRated[i].poster,
                                  color: Colors.white,
                                  date: state.topRated[i].release_date,
                                  rate: state.topRated[i].vote_average,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                          child: Text("Popular Streaming & Tv",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0;
                                  i < state.tvpopularShows.length;
                                  i++)
                                MoviePoster(
                                  isMovie: false,
                                  id: state.tvpopularShows[i].id,
                                  name: state.tvpopularShows[i].title,
                                  backdrop: state.tvpopularShows[i].backdrop,
                                  poster: state.tvpopularShows[i].poster,
                                  color: Colors.white,
                                  date: state.tvpopularShows[i].release_date,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text("Upcoming",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0; i < state.upcoming.length; i++)
                                MoviePoster(
                                  isMovie: true,
                                  id: state.upcoming[i].id,
                                  name: state.upcoming[i].title,
                                  backdrop: state.upcoming[i].backdrop,
                                  poster: state.upcoming[i].poster,
                                  color: Colors.white,
                                  date: state.upcoming[i].release_date,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text("Now playing",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0; i < state.nowPlaying.length; i++)
                                MoviePoster(
                                  isMovie: true,
                                  id: state.nowPlaying[i].id,
                                  name: state.nowPlaying[i].title,
                                  backdrop: state.nowPlaying[i].backdrop,
                                  poster: state.nowPlaying[i].poster,
                                  color: Colors.white,
                                  date: state.nowPlaying[i].release_date,
                                )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                          child: Text("Top rated Tv shows all time",
                              style: heading.copyWith(color: Colors.white)),
                        ),
                        SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              for (var i = 0; i < state.topShows.length; i++)
                                BackdropPoster(
                                  isMovie: false,
                                  id: state.topShows[i].id,
                                  name: state.topShows[i].title,
                                  backdrop: state.topShows[i].backdrop,
                                  poster: state.topShows[i].poster,
                                  color: Colors.white,
                                  date: state.topShows[i].release_date,
                                  rate: state.topShows[i].vote_average,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is HomeError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

class IntroContainer extends StatelessWidget {
  final MovieModel tranding;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const IntroContainer({
    Key? key,
    required this.tranding,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          screen: BlocProvider(
            create: (context) =>
                MoviesInfoBloc()..add(LoadMoviesInfo(id: tranding.id)),
            child: MoivesInfo(
              image: tranding.backdrop,
              title: tranding.title,
            ),
          ),
          withNavBar: false, // OPTIONAL VALUE. True by default.
          pageTransitionAnimation: PageTransitionAnimation.fade,
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
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: DecoratedIcon(
                          Icons.menu,
                          color: Colors.white,
                          size: 30.0,
                          shadows: [
                            BoxShadow(
                              blurRadius: 42.0,
                              color: Colors.black,
                            ),
                            BoxShadow(
                              blurRadius: 12.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                        onPressed: () {
                          scaffoldKey.currentState!.openDrawer();
                        },
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
                                                rate: tranding.vote_average,
                                                date: tranding.release_date,
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
                                                date: tranding.release_date,
                                                image: tranding.poster,
                                                isMovie: true,
                                                rate: tranding.vote_average,
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
                          icon: DecoratedIcon(
                            Icons.more_horiz,
                            color: Colors.white,
                            size: 30.0,
                            shadows: [
                              BoxShadow(
                                blurRadius: 42.0,
                                color: Colors.black,
                              ),
                              BoxShadow(
                                blurRadius: 12.0,
                                color: Colors.black,
                              ),
                            ],
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
                            Text(
                              tranding.title,
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 26),
                            ),
                            Text(
                              tranding.release_date,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: normalText.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.white.withOpacity(.8),
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
                                    value: ((tranding.vote_average * 5) / 10)
                                        .round(),
                                  ),
                                ),
                                Text(
                                  "  " +
                                      tranding.vote_average.toString() +
                                      "/10",
                                  style: normalText.copyWith(
                                    color: Colors.cyanAccent,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
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

class MoviePoster extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;

  final bool isMovie;
  const MoviePoster({
    Key? key,
    required this.poster,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
  }) : super(key: key);
  moveToInfo(BuildContext context) {
    if (isMovie) {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => MoviesInfoBloc()..add(LoadMoviesInfo(id: id)),
          child: MoivesInfo(
            image: backdrop,
            title: name,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>));
    } else {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => ShowInfoBloc()..add(LoadTvInfo(id: id)),
          child: TvInfo(
            image: backdrop,
            title: name,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          moveToInfo(context);
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

class BackdropPoster extends StatelessWidget {
  final String poster;
  final String name;
  final String backdrop;
  final String date;
  final String id;
  final Color color;
  final double rate;
  final bool isMovie;
  const BackdropPoster({
    Key? key,
    required this.poster,
    required this.rate,
    required this.name,
    required this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
  }) : super(key: key);
  moveToInfo(BuildContext context) {
    if (isMovie) {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => MoviesInfoBloc()..add(LoadMoviesInfo(id: id)),
          child: MoivesInfo(
            image: backdrop,
            title: name,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>));
    } else {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => ShowInfoBloc()..add(LoadTvInfo(id: id)),
          child: TvInfo(
            image: backdrop,
            title: name,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          moveToInfo(context);
        },
        child: Container(
          constraints: BoxConstraints(minHeight: 240),
          child: Column(
            children: [
              Container(
                width: 250,
                height: 150,
                color: Colors.grey.shade900,
                child: CachedNetworkImage(
                  imageUrl: backdrop,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: 250,
                height: 150,
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
                    Text(
                      date,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: normalText.copyWith(
                        fontSize: 16,
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
                        ),
                      ],
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

class HorizontalMoviePoster extends StatelessWidget {
  final String? poster;
  final String? name;
  final String? backdrop;
  final String date;
  final String id;
  final Color color;
  final bool isMovie;
  final double rate;
  const HorizontalMoviePoster({
    Key? key,
    this.poster,
    this.name,
    this.backdrop,
    required this.date,
    required this.id,
    required this.color,
    required this.isMovie,
    required this.rate,
  }) : super(key: key);
  moveToInfo(BuildContext context) {
    if (isMovie) {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => MoviesInfoBloc()..add(LoadMoviesInfo(id: id)),
          child: MoivesInfo(
            image: backdrop!,
            title: name!,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) =>));
    } else {
      pushNewScreen(
        context,
        screen: BlocProvider(
          create: (context) => ShowInfoBloc()..add(LoadTvInfo(id: id)),
          child: TvInfo(
            image: backdrop!,
            title: name!,
          ),
        ),
        withNavBar: false, // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          moveToInfo(context);
        },
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  height: 150,
                  width: 90,
                  color: Colors.grey.shade900,
                  child: CachedNetworkImage(
                    imageUrl: poster!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: normalText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      if (date != "") SizedBox(height: 5),
                      if (date != "")
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
