import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bottom_nav_bar/persistent-tab-view.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/screens/cast_info_screen/bloc/castinfo_bloc.dart';
import 'package:moviedb/screens/cast_info_screen/cast_info_screen.dart';

import '../../../models/movie_model.dart';
import '../../../models/people_model.dart';
import '../../../models/tv_model.dart';

import '../streams/people_stream.dart';
import '../streams/tv_stream.dart';

class SearchResultsPeople extends StatelessWidget {
  final String query;
  final int count;
  const SearchResultsPeople({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: MoviesResultsWidget(
        query: query,
        count: count,
      ),
    );
  }
}

class MoviesResultsWidget extends StatefulWidget {
  final String query;
  final int count;
  const MoviesResultsWidget({
    Key? key,
    required this.query,
    required this.count,
  }) : super(key: key);
  @override
  _MoviesResultsWidgetState createState() => _MoviesResultsWidgetState();
}

class _MoviesResultsWidgetState extends State<MoviesResultsWidget> {
  final GetSearchResultsPeople repo = GetSearchResultsPeople();

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
      if (repo.tvshows.length != widget.count) {
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
            child: StreamBuilder<List<PeopleModel>>(
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
                        GridView(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 9 / 16),
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...repo.tvshows
                                .map((movie) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            screen: BlocProvider(
                                              create: (context) =>
                                                  CastinfoBloc(),
                                              child: CastInFoScreen(
                                                id: movie.id,
                                                backdrop: movie.profile,
                                              ),
                                            ),
                                            withNavBar: false,
                                          );
                                        },
                                        child: Container(
                                          constraints:
                                              BoxConstraints(minHeight: 280),
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.black,
                                                child: CachedNetworkImage(
                                                  imageUrl: movie.profile,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      movie.name,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          normalText.copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList()
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (repo.tvshows.length != widget.count)
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
