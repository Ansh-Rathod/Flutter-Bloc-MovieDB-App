import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/movie_card.dart';
import '../../../widgets/no_results_found.dart';
import 'cubit/genre_results_cubit.dart';

class GenreResults extends StatefulWidget {
  final String query;
  const GenreResults({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<GenreResults> createState() => _GenreResultsState();
}

class _GenreResultsState extends State<GenreResults> {
  ScrollController movieController = ScrollController();
  ScrollController tvController = ScrollController();
  int currentPage = 0;
  late PageController pageViewController;
  @override
  void initState() {
    super.initState();
    pageViewController = PageController(
      initialPage: currentPage,
    );
    movieController.addListener(movieScrollListener);
    tvController.addListener(tvScrollListener);
  }

  void movieScrollListener() {
    if (movieController.offset >= movieController.position.maxScrollExtent &&
        !movieController.position.outOfRange) {
      BlocProvider.of<GenreResultsCubit>(context).loadNextMoviePage();
    }
  }

  void tvScrollListener() {
    if (tvController.offset >= tvController.position.maxScrollExtent &&
        !tvController.position.outOfRange) {
      BlocProvider.of<GenreResultsCubit>(context).loadNextTvPage();
    }
  }

  @override
  void dispose() {
    movieController.dispose();
    tvController.dispose();
    pageViewController.dispose();

    super.dispose();
  }

  var buttons = ['Movies', 'Tv'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<GenreResultsCubit, GenreResultsState>(
        builder: (context, state) {
      return Stack(
        children: [
          PageView(
            onPageChanged: (i) {
              setState(() {
                currentPage = i;
              });
              if (i == 1) {
                if (state.shows.isEmpty) {
                  BlocProvider.of<GenreResultsCubit>(context)
                      .initTv(widget.query);
                }
              }
            },
            controller: pageViewController,
            children: [
              state.movieStatus != MovieStatus.loading
                  ? ListView(
                      controller: movieController,
                      children: [
                        const SizedBox(
                          height: 126,
                        ),
                        if (state.movies.isEmpty) const NoResultsFound(),
                        ...state.movies.map(
                          (movie) => HorizontalMovieCard(
                            backdrop: movie.backdrop,
                            color: Colors.white,
                            date: movie.releaseDate,
                            isMovie: true,
                            id: movie.id,
                            name: movie.title,
                            poster: movie.poster,
                            rate: movie.voteAverage,
                          ),
                        ),
                        if (state.movieStatus == MovieStatus.adding)
                          Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade700,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                      ],
                    )
                  : state.movieStatus == MovieStatus.loading
                      ? Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey.shade700,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : const Center(
                          child: ErrorPage(),
                        ),
              state.tvStatus != TvStatus.loading
                  ? ListView(
                      controller: tvController,
                      children: [
                        const SizedBox(
                          height: 126,
                        ),
                        if (state.shows.isEmpty) const NoResultsFound(),
                        ...state.shows.map(
                          (movie) => HorizontalMovieCard(
                            backdrop: movie.backdrop,
                            color: Colors.white,
                            date: movie.releaseDate,
                            isMovie: false,
                            id: movie.id,
                            name: movie.title,
                            poster: movie.poster,
                            rate: movie.voteAverage,
                          ),
                        ),
                        if (state.tvStatus == TvStatus.adding)
                          Center(
                            child: LinearProgressIndicator(
                              backgroundColor: Colors.grey.shade700,
                              color: Theme.of(context).primaryColor,
                            ),
                          )
                      ],
                    )
                  : state.tvStatus == TvStatus.loading
                      ? Center(
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey.shade700,
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      : const Center(
                          child: ErrorPage(),
                        ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border(
                      bottom:
                          BorderSide(color: Colors.grey.shade900, width: .6))),
              child: SafeArea(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          InkWell(
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Icon(
                                CupertinoIcons.back,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          Text(
                            widget.query,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ...buttons.map(
                              (button) => Container(
                                margin: const EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        currentPage == buttons.indexOf(button)
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey.shade700,
                                    width: .6,
                                  ),
                                  color: currentPage == buttons.indexOf(button)
                                      ? Colors.cyanAccent
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: InkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 4),
                                    child: Text(
                                      button,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: currentPage ==
                                                buttons.indexOf(button)
                                            ? Colors.black
                                            : Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentPage = buttons.indexOf(button);
                                    });

                                    pageViewController.animateToPage(
                                        currentPage,
                                        duration:
                                            const Duration(microseconds: 1000),
                                        curve: Curves.bounceInOut);
                                    if (currentPage == 1) {
                                      if (state.shows.isEmpty) {
                                        BlocProvider.of<GenreResultsCubit>(
                                                context)
                                            .initTv(widget.query);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }));
  }
}
