import 'dart:math';

import 'package:amd/widgets/Error_page.dart';
import 'package:amd/widgets/episode_info.dart';
import 'package:amd/widgets/trailers_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

import 'package:amd/models/movie_info_model.dart';
import 'package:amd/models/season_info.dart';
import 'package:amd/screeens/info_pages/get_cast_movie/cast_info.dart';
import 'package:amd/screeens/info_pages/season_info/bloc/season_info_bloc.dart';
import 'package:amd/screeens/info_pages/tv_shows_info/bloc/show_info_bloc.dart';
import 'package:amd/widgets/appbar.dart';
import 'package:amd/widgets/castList.dart';
import 'package:amd/widgets/loading.dart';
import 'package:amd/widgets/star_icon.dart';

import '../../../themes.dart';

class SeasonInfo extends StatelessWidget {
  final String image;
  final String title;

  const SeasonInfo({
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
          body: BlocBuilder<SeasonInfoBloc, SeasonInfoState>(
            builder: (context, state) {
              if (state is SeasonInfoLoading) {
                return Loading(image: image);
              } else if (state is SeasonInfoLoaded) {
                return SeasonInfoWidget(
                  info: state.seasonInfo,
                  castList: state.cast,
                  textColor: state.textColor,
                  color: state.color,
                  backdrop: image,
                  title: title,
                  trailers: state.trailers,
                  backdrops: state.backdrops,
                );
              } else if (state is SeasonInfoLoadError) {
                return ErrorPage();
              } else {
                return Container();
              }
            },
          )),
    );
  }
}

class SeasonInfoWidget extends StatelessWidget {
  final SeasonModel info;
  final List<CastInfo> castList;
  final Color color;
  final String backdrop;
  final String title;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final Color textColor;
  const SeasonInfoWidget({
    Key? key,
    required this.info,
    required this.castList,
    required this.color,
    required this.backdrop,
    required this.title,
    required this.backdrops,
    required this.trailers,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBarCast(
            color: color,
            textColor: textColor,
            title: '',
            image: info.posterPath,
          ),
          SliverToBoxAdapter(
            child: Container(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: heading.copyWith(color: textColor, fontSize: 24),
                  ),
                  SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: normalText.copyWith(
                          color: textColor, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: info.customDate + " | ",
                        ),
                        TextSpan(
                          text: info.episodes.length.toString() + " Episodes",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  SizedBox(height: 5),
                ],
              ),
            )),
          ),
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
                    info.overview == "N/A"
                        ? "${title} premiered on " + info.customDate
                        : info.overview,
                    trimLines: 8,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: normalText.copyWith(
                        fontWeight: FontWeight.w500, color: textColor),
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          if (trailers.isNotEmpty)
            TrailersWidget(
                textColor: textColor,
                trailers: trailers,
                backdrops: backdrops,
                backdrop: backdrop),
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
          if (info.episodes.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Episodes",
                        style: heading.copyWith(color: textColor)),
                  ),
                ],
              ),
            ),
          for (var i = 0; i < info.episodes.length; i++)
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      context: context,
                      builder: (context) {
                        return BottomSheet(
                          builder: (context) => EpisodeInfo(
                            color: color,
                            model: info.episodes[i],
                            textColor: textColor,
                          ),
                          onClosing: () {},
                        );
                      });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .8,
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: info.episodes[i].stillPath,
                            ),
                          ),
                          Positioned(
                              child: Container(
                                  color: color,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(info.episodes[i].number,
                                        style:
                                            heading.copyWith(color: textColor)),
                                  )))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: info.episodes[i].name,
                                    style: heading.copyWith(
                                        color: textColor, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              info.episodes[i].customDate,
                              style: heading.copyWith(
                                  color: textColor.withOpacity(.8),
                                  fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                IconTheme(
                                  data: IconThemeData(
                                    color: textColor == Colors.white
                                        ? Colors.amber
                                        : Colors.cyanAccent,
                                    size: 20,
                                  ),
                                  child: StarDisplay(
                                    value: ((info.episodes[i].voteAverage * 5) /
                                            10)
                                        .round(),
                                  ),
                                ),
                                Text(
                                  "  " +
                                      info.episodes[i].voteAverage.toString() +
                                      "/10",
                                  style: normalText.copyWith(
                                    color: textColor == Colors.white
                                        ? Colors.amber
                                        : Colors.blue,
                                    letterSpacing: 1.2,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
