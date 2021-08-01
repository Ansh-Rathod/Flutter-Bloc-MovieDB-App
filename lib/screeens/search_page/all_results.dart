import 'package:amd/screeens/search_page/search_results/all_people_search_results.dart';
import 'package:amd/screeens/search_page/search_results/all_tv_search_results.dart';
import 'package:amd/widgets/Error_page.dart';
import 'package:amd/widgets/no_results_found.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:amd/models/movie_model.dart';
import 'package:amd/models/people_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/screeens/home/home.dart';
import 'package:amd/screeens/info_pages/get_cast_movie/bloc/cast_movies_bloc.dart';
import 'package:amd/screeens/info_pages/get_cast_movie/cast_info.dart';
import 'package:amd/screeens/search_page/bloc/search_results_bloc.dart';
import 'package:amd/screeens/search_page/search_results/all_movies_search_results.dart';
import 'package:amd/widgets/loading.dart';
import 'package:bottom_nav_bar/persistent-tab-view.dart';

import '../../themes.dart';

class AllSearchResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: scaffoldColor,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
          builder: (context, state) {
            if (state is SearchResultsLoading) {
              return SearchLoading();
            } else if (state is SearchResultsLoaded) {
              return SearchResultsWidget(
                movies: state.movies,
                shows: state.shows,
                showsCount: state.showsCount,
                movieCount: state.moviesCount,
                query: state.query,
                people: state.people,
                peopleCount: state.peopleCount,
              );
            } else if (state is SearchResultsError) {
              return ErrorPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class SearchResultsWidget extends StatelessWidget {
  final List<MovieModel> movies;
  final List<TvModel> shows;
  final List<PeopleModel> people;
  final String query;
  final int movieCount;
  final int showsCount;
  final int peopleCount;

  const SearchResultsWidget({
    Key? key,
    required this.movies,
    required this.shows,
    required this.people,
    required this.query,
    required this.movieCount,
    required this.showsCount,
    required this.peopleCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (movies.isEmpty && shows.isEmpty && people.isEmpty)
            Center(child: NoResultsFound()),
          if (movies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Movies ",
                        ),
                        TextSpan(
                          text: "(${movieCount} results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (movieCount > 20)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResults(
                                  query: query,
                                  count: movieCount,
                                )));
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.cyanAccent,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (movies.isNotEmpty)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < movies.length; i++)
                    MoviePoster(
                      isMovie: true,
                      id: movies[i].id,
                      name: movies[i].title,
                      backdrop: movies[i].backdrop,
                      poster: movies[i].poster,
                      color: Colors.white,
                      date: movies[i].release_date,
                    )
                ],
              ),
            ),
          if (shows.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "Tv Shows ",
                        ),
                        TextSpan(
                          text: "(${showsCount} results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (showsCount > 20)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResultsTv(
                                  query: query,
                                  results: showsCount,
                                )));
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.cyanAccent,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (shows.isNotEmpty)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < shows.length; i++)
                    MoviePoster(
                      isMovie: false,
                      id: shows[i].id,
                      name: shows[i].title,
                      backdrop: shows[i].backdrop,
                      poster: shows[i].poster,
                      color: Colors.white,
                      date: shows[i].release_date,
                    )
                ],
              ),
            ),
          if (people.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: heading.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: "People ",
                        ),
                        TextSpan(
                          text: "(${peopleCount} results)",
                          style: heading.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white.withOpacity(.6)),
                        ),
                      ],
                    ),
                  ),
                  if (peopleCount > 20)
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SearchResultsPeople(
                                  query: query,
                                  count: peopleCount,
                                )));
                      },
                      child: Text(
                        "See all",
                        style: normalText.copyWith(
                          color: Colors.cyanAccent,
                        ),
                      ),
                    )
                ],
              ),
            ),
          if (people.isNotEmpty)
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < people.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: BlocProvider(
                              create: (context) => CastMoviesBloc()
                                ..add(LoadCastInfo(id: people[i].id)),
                              child: CastPersonalInfoScreen(
                                image: people[i].profile,
                                title: people[i].name,
                              ),
                            ),
                            withNavBar:
                                false, // OPTIONAL VALUE. True by default.
                            pageTransitionAnimation:
                                PageTransitionAnimation.fade,
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints(minHeight: 280),
                          child: Column(
                            children: [
                              Container(
                                height: 200,
                                width: 130,
                                color: Colors.black,
                                child: CachedNetworkImage(
                                  imageUrl: people[i].profile,
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
                                      people[i].name,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: normalText.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
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
                    )
                ],
              ),
            ),
        ],
      ),
    );
  }
}
