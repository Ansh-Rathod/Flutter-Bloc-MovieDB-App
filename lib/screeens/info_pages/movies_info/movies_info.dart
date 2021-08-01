import 'dart:math';

import 'package:amd/screeens/info_pages/season_info/season_info.dart';
import 'package:amd/widgets/Error_page.dart';
import 'package:amd/widgets/image_view.dart';
import 'package:amd/widgets/like_button/cubit/like_movie_cubit.dart';
import 'package:amd/widgets/like_button/fav_button.dart';
import 'package:amd/widgets/trailers_widget.dart';
import 'package:amd/widgets/watchlist_button/cubit/watchlist_cubit.dart';
import 'package:amd/widgets/watchlist_button/watchl_ist_button.dart';
import 'package:flutter/services.dart';

import '../../../widgets/star_icon.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/castList.dart';
import '../../../widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:palette_generator/palette_generator.dart';

import '../../../models/movie_info_model.dart';
import '../../../models/movie_model.dart';
import '../../home/home.dart';
import 'bloc/movies_info_bloc.dart';
import '../../../themes.dart';
import '../../../widgets/expandable.dart';
import 'package:readmore/readmore.dart';

class MoivesInfo extends StatelessWidget {
  final String image;
  final String title;

  const MoivesInfo({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
          backgroundColor: Colors.black,
          body: BlocBuilder<MoviesInfoBloc, MoviesInfoState>(
            builder: (context, state) {
              if (state is MoviesInfoLoading) {
                return Loading(image: image);
              } else if (state is MoviesInfoLoaded) {
                List<ImageBackdrop> images = [];

                images.add(ImageBackdrop(image: state.tmdbData.backdrops));
                images.addAll(state.images);
                print(state.color);
                return MovieInfoScrollableWidget(
                  info: state.tmdbData,
                  backdrops: state.backdrops,
                  similar: state.similar,
                  castList: state.cast,
                  images: images,
                  color: state.color,
                  imdbInfo: state.imdbData,
                  trailers: state.trailers,
                  textColor: state.textColor,
                );
              } else if (state is MoviesInfoError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class MovieInfoScrollableWidget extends StatelessWidget {
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final Color textColor;
  final List<MovieModel> similar;
  final Color color;
  const MovieInfoScrollableWidget({
    Key? key,
    required this.info,
    required this.imdbInfo,
    required this.backdrops,
    required this.trailers,
    required this.castList,
    required this.textColor,
    required this.similar,
    required this.color,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBarWithShadow(
            image: info.backdrops,
            title: info.title,
            color: color,
            textColor: textColor,
            id: info.tmdbId,
            isMovie: true,
            poster: info.poster,
            releaseDate: info.dateByMonth,
            homepage: info.homepage,
            images: images,
            rate: info.rateing,
          ),
          SliverToBoxAdapter(
            child: Container(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPhotos(
                                imageList: [
                                  ImageBackdrop(image: info.poster),
                                  ImageBackdrop(image: info.backdrops),
                                ],
                                imageIndex: 0,
                                color: color,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: CachedNetworkImage(
                              imageUrl: info.poster, width: 120),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: info.title,
                                    style: heading.copyWith(
                                        color: textColor, fontSize: 22),
                                  ),
                                  TextSpan(
                                    text:
                                        " (${info.releaseDate.split("-")[0]})",
                                    style: heading.copyWith(
                                        color: textColor.withOpacity(.8),
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              imdbInfo.genre,
                              style: normalText.copyWith(color: textColor),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                IconTheme(
                                  data: IconThemeData(
                                    color: textColor == Colors.white
                                        ? Colors.amber
                                        : Colors.blue,
                                    size: 20,
                                  ),
                                  child: StarDisplay(
                                    value: ((info.rateing * 5) / 10).round(),
                                  ),
                                ),
                                Text(
                                  "  " + info.rateing.toString() + "/10",
                                  style: normalText.copyWith(
                                    color: textColor == Colors.white
                                        ? Colors.amber
                                        : Colors.blue,
                                    letterSpacing: 1.2,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5),
                            BlocProvider(
                              create: (context) =>
                                  LikeMovieCubit()..init(info.tmdbId),
                              child: FavirIcon(
                                date: info.dateByMonth,
                                image: info.poster,
                                isMovie: true,
                                title: info.title,
                                rate: info.rateing,
                                movieid: info.tmdbId,
                                likeColor: textColor == Colors.black
                                    ? Colors.blue
                                    : Colors.amber,
                                unLikeColor: textColor,
                                backdrop: info.backdrops,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
          if (info.overview != '')
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Overview", style: heading.copyWith(color: textColor)),
                    SizedBox(height: 10),
                    ReadMoreText(
                      info.overview,
                      trimLines: 6,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: normalText.copyWith(
                          fontWeight: FontWeight.w500, color: textColor),
                      moreStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          if (trailers.isNotEmpty)
            TrailersWidget(
              textColor: textColor,
              trailers: trailers,
              backdrops: backdrops,
              backdrop: info.backdrops,
            ),
          if (castList.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child:
                        Text("Cast", style: heading.copyWith(color: textColor)),
                  ),
                  CastList(castList: castList, textColor: textColor),
                ],
              ),
            ),
          SliverToBoxAdapter(
            child: ExpandableGroup(
              isExpanded: true,
              expandedIcon: Icon(
                Icons.arrow_drop_up,
                color: textColor != Colors.white ? Colors.black : Colors.white,
              ),
              collapsedIcon: Icon(
                Icons.arrow_drop_down,
                color: textColor != Colors.white ? Colors.black : Colors.white,
              ),
              header: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "About Movie",
                  style: heading.copyWith(color: textColor),
                ),
              ),
              items: [
                ListTile(
                    title: Text(
                      "Runtime",
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.runtime,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "Writers",
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.writer,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "Director",
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.director,
                      style: normalText.copyWith(color: textColor),
                    )),
                ListTile(
                    title: Text(
                      "Released on/Releasing on",
                      style: heading.copyWith(color: textColor, fontSize: 16),
                    ),
                    subtitle: Text(
                      imdbInfo.released,
                      style: normalText.copyWith(color: textColor),
                    )),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: ExpandableGroup(
                isExpanded: false,
                expandedIcon: Icon(
                  Icons.arrow_drop_up,
                  color:
                      textColor != Colors.white ? Colors.black : Colors.white,
                ),
                collapsedIcon: Icon(
                  Icons.arrow_drop_down,
                  color:
                      textColor != Colors.white ? Colors.black : Colors.white,
                ),
                header: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Movie on Boxoffice",
                    style: heading.copyWith(color: textColor),
                  ),
                ),
                items: [
                  ListTile(
                      title: Text(
                        "Rated",
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      subtitle: Text(
                        imdbInfo.rated,
                        style: normalText.copyWith(color: textColor),
                      )),
                  ListTile(
                      title: Text(
                        "Budget",
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      subtitle: Text(
                        k_m_b_generator(info.budget) == "0"
                            ? "N/A"
                            : k_m_b_generator(info.budget),
                        style: normalText.copyWith(color: textColor),
                      )),
                  ListTile(
                      title: Text(
                        "BoxOffice",
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      subtitle: Text(
                        imdbInfo.boxOffice,
                        style: normalText.copyWith(color: textColor),
                      )),
                ],
              ),
            ),
          ),
          if (similar.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("You might also like",
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < similar.length; i++)
                          MoviePoster(
                            isMovie: true,
                            id: similar[i].id,
                            name: similar[i].title,
                            backdrop: similar[i].backdrop,
                            poster: similar[i].poster,
                            color: textColor,
                            date: similar[i].release_date,
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 30))
        ],
      ),
    );
  }

  String k_m_b_generator(num) {
    if (num > 999 && num < 99999) {
      return "${(num / 1000).toStringAsFixed(1)} K";
    } else if (num > 99999 && num < 999999) {
      return "${(num / 1000).toStringAsFixed(0)} K";
    } else if (num > 999999 && num < 999999999) {
      return "${(num / 1000000).toStringAsFixed(1)} M";
    } else if (num > 999999999) {
      return "${(num / 1000000000).toStringAsFixed(1)} B";
    } else {
      return num.toString();
    }
  }
}
