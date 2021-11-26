import 'package:flutter/material.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/widgets/movie_card.dart';

import '../../../models/movie_model.dart';
import '../../../models/tv_model.dart';
import '../streams/tv_stream.dart';

class AllSearchResultsTv extends StatelessWidget {
  final String query;
  final int results;
  const AllSearchResultsTv({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: MoviesResultsWidget(
        query: query,
        results: results,
      ),
    );
  }
}

class MoviesResultsWidget extends StatefulWidget {
  final String query;
  final int results;

  const MoviesResultsWidget({
    Key? key,
    required this.query,
    required this.results,
  }) : super(key: key);
  @override
  _MoviesResultsWidgetState createState() => _MoviesResultsWidgetState();
}

class _MoviesResultsWidgetState extends State<MoviesResultsWidget> {
  final GetSearchResultsTv repo = GetSearchResultsTv();

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
      if (repo.tvshows.length != widget.results) {
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
        SliverAppBar(
          backgroundColor: scaffoldColor,
          brightness: Brightness.dark,
          elevation: 0,
          pinned: true,
          title: Text(
            "Results for \"${widget.query}\"",
            style: heading.copyWith(color: Colors.white),
          ),
        ),
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
                            ...repo.tvshows
                                .map((movie) => HorizontalMovieCard(
                                      isMovie: false,
                                      rate: movie.voteAverage,
                                      id: movie.id,
                                      name: movie.title,
                                      backdrop: movie.backdrop,
                                      poster: movie.poster,
                                      color: Colors.white,
                                      date: movie.releaseDate,
                                    ))
                                .toList()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (repo.tvshows.length != widget.results)
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
