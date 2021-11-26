import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:moviedb/constants.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';
import 'package:moviedb/screens/home_screen/bloc/fetch_home_bloc.dart';
import 'package:moviedb/widgets/header_text.dart';
import 'package:moviedb/widgets/horizontal_list_cards.dart';
import 'package:moviedb/widgets/intro_widget.dart';
import 'package:moviedb/widgets/movie_card.dart';
import 'package:moviedb/widgets/no_results_found.dart';

import '../../animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FetchHomeBloc homeBloc;
  @override
  void initState() {
    homeBloc = BlocProvider.of<FetchHomeBloc>(context);
    homeBloc.add(FetchHomeData());
    super.initState();
  }

  @override
  void dispose() {
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: Colors.black,
          extendBody: true,
          extendBodyBehindAppBar: true,
          body: BlocBuilder<FetchHomeBloc, FetchHomeState>(
            builder: (context, state) {
              if (state is FetchHomeLoaded)
                return HomeScreenWidget(
                  topRated: state.topRated,
                  topShows: state.topShows,
                  nowPlaying: state.nowPlaying,
                  tvShows: state.topShows,
                  tranding: state.tranding,
                  upcoming: state.upcoming,
                );
              else if (state is FetchHomeError)
                return ErrorPage();
              else if (state is FetchHomeLoading)
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.cyanAccent,
                    ),
                  ),
                );

              return Container();
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreenWidget extends StatelessWidget {
  final List<MovieModel> tranding;
  final List<MovieModel> topRated;
  final List<TvModel> tvShows;
  final List<TvModel> topShows;
  final List<MovieModel> upcoming;
  final List<MovieModel> nowPlaying;
  const HomeScreenWidget({
    Key? key,
    required this.tranding,
    required this.topRated,
    required this.tvShows,
    required this.topShows,
    required this.upcoming,
    required this.nowPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DelayedDisplay(
                  delay: Duration(microseconds: 700),
                  child: HeaderText(text: "In Theaters")),
              DelayedDisplay(
                delay: Duration(microseconds: 800),
                child: HorizontalListViewMovies(
                  list: tranding,
                ),
              ),
              HeaderText(text: "Tv shows"),
              HorizontalListViewTv(
                list: tvShows,
              ),
              HeaderText(text: "Top Rated"),
              HorizontalListViewMovies(
                list: topRated,
              ),
              HeaderText(text: "Top rated Tv shows"),
              HorizontalListViewTv(
                list: topShows,
              ),
              HeaderText(text: "Upcoming"),
              HorizontalListViewMovies(
                list: upcoming,
              ),
              HeaderText(text: "Now playing"),
              HorizontalListViewMovies(
                list: nowPlaying,
              )
            ],
          ),
        ),
      ),
    );
  }
}
