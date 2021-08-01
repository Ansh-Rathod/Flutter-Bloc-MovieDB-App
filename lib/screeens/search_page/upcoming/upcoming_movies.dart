import 'package:amd/models/genres_model.dart';
import 'package:amd/screeens/home/home.dart';
import 'package:amd/screeens/search_page/bloc/search_results_bloc.dart';
import 'package:amd/screeens/search_page/upcoming/bloc/upcoming_bloc.dart';
import 'package:amd/themes.dart';
import 'package:amd/widgets/Error_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../search_page.dart';

class UpcomingMoviesResults extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingMoviesBloc, UpcomingMoviesState>(
      builder: (context, state) {
        if (state is UpcomingMoviesLoading) {
          return SearchLoading();
        } else if (state is UpcomingMoviesLoaded) {
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  "Genres",
                  style: heading.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Text(
                  "Currently on air Shows",
                  style: heading.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < state.tvshows.length; i++)
                      MoviePoster(
                        isMovie: false,
                        id: state.tvshows[i].id,
                        name: state.tvshows[i].title,
                        backdrop: state.tvshows[i].backdrop,
                        poster: state.tvshows[i].poster,
                        color: Colors.white,
                        date: state.tvshows[i].release_date,
                      )
                  ],
                ),
              )
            ],
          );
        } else if (state is UpcomingMoviesError) {
          return ErrorPage();
        } else {
          return Container();
        }
      },
    );
  }
}

class SearchLoading extends StatelessWidget {
  SearchLoading({Key? key}) : super(key: key);
  final genres = GenresList.fromJson(genreslist).list..shuffle();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade900.withOpacity(.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              color: Colors.grey.shade900,
              child: Text(
                "Upcoming Movies",
                style: heading.copyWith(
                  color: Colors.white.withOpacity(.0),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 0, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width * 3,
                child: Wrap(
                  runSpacing: 5,
                  spacing: 5,
                  direction: Axis.horizontal,
                  children: [
                    ...genres
                        .map((genre) => GenreTile(
                              genre: genre,
                            ))
                        .toList(),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Container(
              color: Colors.grey.shade900,
              child: Text(
                "Upcoming Movies",
                style: heading.copyWith(
                  color: Colors.white.withOpacity(.0),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 12),
                for (var i = 0; i < 10; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 200,
                      width: 130,
                      color: Colors.grey.shade900,
                    ),
                  )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
            child: Container(
              color: Colors.grey.shade900,
              child: Text(
                "Upcoming Movies",
                style: heading.copyWith(
                  color: Colors.white.withOpacity(.0),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 12),
                for (var i = 0; i < 10; i++)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      height: 200,
                      width: 130,
                      color: Colors.grey.shade900,
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
