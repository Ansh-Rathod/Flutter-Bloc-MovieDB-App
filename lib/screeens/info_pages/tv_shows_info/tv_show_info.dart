import 'dart:math';

import 'package:amd/screeens/info_pages/tv_shows_info/widgets/seasons_widget.dart';
import 'package:amd/widgets/Error_page.dart';
import 'package:amd/widgets/image_view.dart';
import 'package:amd/widgets/like_button/cubit/like_movie_cubit.dart';
import 'package:amd/widgets/like_button/fav_button.dart';
import 'package:amd/widgets/overview_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';

import 'package:amd/screeens/info_pages/season_info/bloc/season_info_bloc.dart';
import 'package:amd/screeens/info_pages/season_info/season_info.dart';
import 'package:amd/screeens/info_pages/tv_shows_info/widgets/about_shows.dart';
import 'package:amd/widgets/trailers_widget.dart';

import '../../../models/movie_info_model.dart';
import '../../../models/tv_model.dart';
import '../../../models/tv_shows_info.dart';
import '../../../themes.dart';
import '../../../widgets/appbar.dart';
import '../../../widgets/castList.dart';
import '../../../widgets/expandable.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/star_icon.dart';
import '../../home/home.dart';
import '../movies_info/movies_info.dart';
import 'bloc/show_info_bloc.dart';

class TvInfo extends StatelessWidget {
  final String image;
  final String title;

  const TvInfo({
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
          body: BlocBuilder<ShowInfoBloc, ShowInfoState>(
            builder: (context, state) {
              if (state is ShowInfoLoading) {
                return Loading(image: image);
              } else if (state is ShowInfoLoaded) {
                List<ImageBackdrop> images = [];
                images.add(ImageBackdrop(image: state.tmdbData.backdrops));
                images.addAll(state.images);
                print(state.color);
                return TvInfoScrollableWidget(
                  info: state.tmdbData,
                  backdrops: state.backdrops,
                  similar: state.similar,
                  castList: state.cast,
                  color: state.color,
                  trailers: state.trailers,
                  textColor: state.textColor,
                  images: images,
                );
              } else if (state is ShowInfoError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class TvInfoScrollableWidget extends StatelessWidget {
  final TvInfoModel info;
  final List<ImageBackdrop> backdrops;
  final List<ImageBackdrop> images;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final Color textColor;
  final List<TvModel> similar;
  final Color color;
  TvInfoScrollableWidget({
    Key? key,
    required this.info,
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
            images: images,
            color: color,
            textColor: textColor,
            id: info.tmdbId,
            poster: info.poster,
            isMovie: false,
            releaseDate: info.formatedDate,
            homepage: info.homepage,
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
                          width: 120,
                          child: CachedNetworkImage(
                            imageUrl: info.poster,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
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
                                    text: " (${info.date.split("-")[0]})",
                                    style: heading.copyWith(
                                      color: textColor.withOpacity(.8),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            RichText(
                              text: TextSpan(
                                style: normalText.copyWith(color: textColor),
                                children: [
                                  ...info.genres
                                      .map(
                                        (genre) => TextSpan(text: "$genre, "),
                                      )
                                      .toList()
                                ],
                              ),
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
                                date: info.formatedDate,
                                image: info.poster,
                                rate: info.rateing,
                                isMovie: false,
                                title: info.title,
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
            OverviewWidget(textColor: textColor, info: info),
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
          AboutShowWidget(textColor: textColor, info: info),
          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Text("Seasons", style: heading.copyWith(color: textColor)),
            ),
          ),
          ...info.seasons
              .map((season) => SeasonsWidget(
                    info: info,
                    textColor: textColor,
                    season: season,
                  ))
              .toList(),
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
                          isMovie: false,
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
}
