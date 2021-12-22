import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../animation.dart';
import '../../../widgets/movie_card.dart';
import '../../../widgets/no_results_found.dart';
import '../../cast_info_screen/cast_info_screen.dart';
import 'cubit/search_results_cubit.dart';

class SearchResults extends StatefulWidget {
  final String query;
  const SearchResults({
    Key? key,
    required this.query,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  ScrollController movieController = ScrollController();
  ScrollController tvController = ScrollController();
  ScrollController personController = ScrollController();
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
    personController.addListener(personScrollListener);
  }

  void movieScrollListener() {
    if (movieController.offset >= movieController.position.maxScrollExtent &&
        !movieController.position.outOfRange) {
      BlocProvider.of<SearchResultsCubit>(context).loadNextMoviePage();
    }
  }

  void tvScrollListener() {
    if (tvController.offset >= tvController.position.maxScrollExtent &&
        !tvController.position.outOfRange) {
      BlocProvider.of<SearchResultsCubit>(context).loadNextTvPage();
    }
  }

  void personScrollListener() {
    if (personController.offset >= personController.position.maxScrollExtent &&
        !personController.position.outOfRange) {
      BlocProvider.of<SearchResultsCubit>(context).loadNextPersonPage();
    }
  }

  @override
  void dispose() {
    personController.dispose();
    movieController.dispose();
    tvController.dispose();
    pageViewController.dispose();

    super.dispose();
  }

  var buttons = ['Movies', 'Tv', 'Person'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: BlocBuilder<SearchResultsCubit, SearchResultsState>(
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
                  BlocProvider.of<SearchResultsCubit>(context)
                      .initTv(widget.query);
                }
              }
              if (i == 2) {
                if (state.people.isEmpty) {
                  BlocProvider.of<SearchResultsCubit>(context)
                      .initPeople(widget.query);
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
                          height: 120,
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
                          height: 120,
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
              state.peopleStatus != PeopleStatus.loading
                  ? Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: GridView(
                        controller: personController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 9 / 16,
                          crossAxisCount: 2,
                        ),
                        children: [
                          if (state.shows.isEmpty) const NoResultsFound(),
                          ...state.people.map((movie) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: InkWell(
                                  onTap: () {
                                    pushNewScreen(
                                        context,
                                        CastInFoScreen(
                                            id: movie.id, backdrop: ''));
                                  },
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: AspectRatio(
                                          aspectRatio: 9 / 14,
                                          child: CachedNetworkImage(
                                            imageUrl: movie.profile,
                                            fit: BoxFit.cover,
                                            progressIndicatorBuilder: (context,
                                                    url, downloadProgress) =>
                                                Container(
                                              color: Colors.grey.shade900,
                                              child: Center(
                                                child: SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Colors
                                                              .grey.shade700,
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          strokeWidth: 1,
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        movie.name,
                                        maxLines: 2,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          if (state.peopleStatus == PeopleStatus.adding)
                            Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.grey.shade700,
                                color: Theme.of(context).primaryColor,
                              ),
                            )
                        ],
                      ),
                    )
                  : state.peopleStatus == PeopleStatus.loading
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
                      : const Center(child: ErrorPage()),
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
                            'Results for "${widget.query}"',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
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
                                        BlocProvider.of<SearchResultsCubit>(
                                                context)
                                            .initTv(widget.query);
                                      }
                                    }
                                    if (currentPage == 2) {
                                      if (state.people.isEmpty) {
                                        BlocProvider.of<SearchResultsCubit>(
                                                context)
                                            .initPeople(widget.query);
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
