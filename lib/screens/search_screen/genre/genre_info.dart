import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/widgets/movie_card.dart';

import '../../../constants.dart';
import '../../../models/movie_model.dart';
import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';

import '../streams/genre_movies.dart';
import '../streams/genre_tv.dart';
import '../streams/movies_stream.dart';
import '../streams/tv_stream.dart';

class GenreInfo extends StatelessWidget {
  final String id;
  final String title;
  const GenreInfo({
    Key? key,
    required this.id,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: DefaultTabController(
          initialIndex: 0,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: scaffoldColor,
              elevation: 0,
              brightness: Brightness.dark,
              title: Text(title, style: heading.copyWith(color: Colors.white)),
              bottom: TabBar(
                indicatorColor: Colors.cyanAccent,
                labelStyle: normalText.copyWith(color: Colors.white),
                labelColor: Colors.white,
                labelPadding: EdgeInsets.only(top: 10.0),
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    text: 'Movies',
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                  Tab(
                    text: 'Tv shows',
                    iconMargin: EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                SearchResults(
                  query: id.toString(),
                  count: 100,
                ),
                SearchResultsTv(
                  results: 200,
                  query: id.toString(),
                ),
              ],
            ),
          )),
    );
  }
}

class SearchResults extends StatelessWidget {
  final String query;
  final int count;
  const SearchResults({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: MoviesGenreWidget(
        count: count,
        query: query,
      ),
    );
  }
}

class MoviesGenreWidget extends StatefulWidget {
  final String query;
  final int count;
  const MoviesGenreWidget({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  _MoviesGenreWidgetState createState() => _MoviesGenreWidgetState();
}

class _MoviesGenreWidgetState extends State<MoviesGenreWidget> {
  final GenreMovies repo = GenreMovies();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(widget.query);
        print("at the end of list");
      }
    }
  }

  @override
  void dispose() {
    repo.dispose();
    repo.controller.close();
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
            child: StreamBuilder<List<MovieModel>>(
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
                  return Container(
                    child: Column(
                      children: [
                        ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            ...repo.movies
                                .map((movie) => HorizontalMovieCard(
                                      isMovie: true,
                                      id: movie.id,
                                      name: movie.title,
                                      backdrop: movie.backdrop,
                                      poster: movie.poster,
                                      color: Colors.white,
                                      date: movie.releaseDate,
                                      rate: movie.voteAverage,
                                    ))
                                .toList()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!repo.isfinish)
                          Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            color: Colors.cyanAccent,
                          ))
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Look like you reach the end!",
                                style: normalText.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
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

class SearchResultsTv extends StatelessWidget {
  final String query;
  final int results;
  const SearchResultsTv({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: MoviesGenreTvWidget(
        query: query,
        results: results,
      ),
    );
  }
}

class MoviesGenreTvWidget extends StatefulWidget {
  final String query;
  final int results;

  const MoviesGenreTvWidget({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  _MoviesGenreTvWidgetState createState() => _MoviesGenreTvWidgetState();
}

class _MoviesGenreTvWidgetState extends State<MoviesGenreTvWidget> {
  final GenreTv repo = GenreTv();

  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    repo.addData(widget.query);
    controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("at the end of list");
      if (!repo.isfinish) {
        repo.getNextMovies(widget.query);
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
            child: StreamBuilder<List<TvModel>>(
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
                  return Container(
                    child: Column(
                      children: [
                        ListView(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            ...repo.tvshows
                                .map((movie) => HorizontalMovieCard(
                                      isMovie: false,
                                      id: movie.id,
                                      name: movie.title,
                                      backdrop: movie.backdrop,
                                      poster: movie.poster,
                                      color: Colors.white,
                                      date: movie.releaseDate,
                                      rate: movie.voteAverage,
                                    ))
                                .toList()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (!repo.isfinish)
                          Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.black,
                            color: Colors.cyanAccent,
                          ))
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Look like you reach the end!",
                                style: normalText.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  );
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
