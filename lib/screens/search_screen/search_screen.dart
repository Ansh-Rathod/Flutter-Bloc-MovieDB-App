import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/models/genre_model.dart';

import '../../constants.dart';
import 'all_search_results.dart';
import 'bloc/search_results_bloc.dart';
import 'genre/genre_info.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final genres = GenresList.fromJson(genreslist).list;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: scaffoldColor,
            body: SafeArea(
              child: Container(
                color: scaffoldColor,
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        child: Text(
                          "Search",
                          style: heading.copyWith(
                              color: Colors.cyanAccent, fontSize: 28),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        style: normalText,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: "Search movies,tv shows or cast...",
                            hintStyle: normalText,
                            fillColor: Colors.white,
                            filled: true,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            )),
                        onSubmitted: (query) {
                          if (query != null && query.isNotEmpty) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) => SearchResultsBloc()
                                    ..add(LoadSearchResults(query: query)),
                                  child: AllSearchResults(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        "Popular Genres",
                        style: heading.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 28 / 16),
                        children: [
                          for (var i = 0; i < 4; i++)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GenreTile(
                                genre: genres[i],
                              ),
                            )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text(
                        "Browes all",
                        style: heading.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 28 / 16),
                        children: [
                          for (var i = 4; i < genres.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: GenreTile(
                                genre: genres[i],
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GenreTile extends StatelessWidget {
  final Genres genre;
  GenreTile({
    Key? key,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (conetex) => GenreInfo(
                    id: genre.id,
                    title: genre.name,
                  )));
        },
        child: Container(
          color: genre.color,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: double.infinity,
              ),
              Positioned(
                bottom: -5,
                right: -20,
                child: RotationTransition(
                  turns: new AlwaysStoppedAnimation(380 / 360),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: CachedNetworkImage(
                      imageUrl: genre.image,
                      fit: BoxFit.cover,
                      width: 65,
                      height: 75,
                    ),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: Text(
                    genre.name,
                    style: normalText.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
