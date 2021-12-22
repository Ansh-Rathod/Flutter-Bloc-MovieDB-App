import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';
import '../../constants.dart';
import '../../models/movie_model.dart';
import '../../models/season_details_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cast_list.dart';
import '../../widgets/draggable_sheet.dart';
import '../../widgets/no_results_found.dart';
import '../../widgets/star_icon_display.dart';
import '../../widgets/trailer_widget.dart';
import '../movie_info_screen/movie_Info_screen.dart';
import 'bloc/season_detail_bloc.dart';

class SeasonDetailScreen extends StatefulWidget {
  final String id;
  final String backdrop;
  final String snum;
  const SeasonDetailScreen({
    Key? key,
    required this.id,
    required this.backdrop,
    required this.snum,
  }) : super(key: key);

  @override
  SeasonDetailScreenState createState() => SeasonDetailScreenState();
}

class SeasonDetailScreenState extends State<SeasonDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SeasonDetailBloc()
        ..add(LoadSeasonInfo(id: widget.id, snum: widget.snum)),
      child: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
        builder: (context, state) {
          if (state is SeasonDetailLoaded) {
            return SeasonInfoWidget(
              info: state.seasonDetail,
              tvId: widget.id,
              castList: state.cast,
              textColor: Colors.white,
              color: Colors.black,
              backdrop: widget.backdrop,
              trailers: state.trailers,
              backdrops: state.backdrops,
            );
          } else if (state is SeasonDetailError) {
            return const ErrorPage();
          } else if (state is SeasonDetailLoading) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.grey.shade700,
                  strokeWidth: 2,
                  backgroundColor: Colors.cyanAccent,
                ),
              ),
            );
          }

          return const Scaffold();
        },
      ),
    );
  }
}

class SeasonInfoWidget extends StatelessWidget {
  final SeasonModel info;
  final List<CastInfo> castList;
  final Color color;
  final String backdrop;
  final String tvId;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final Color textColor;
  const SeasonInfoWidget({
    Key? key,
    required this.info,
    required this.castList,
    required this.color,
    required this.backdrop,
    required this.tvId,
    required this.backdrops,
    required this.trailers,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(info.posterPath),
              fit: BoxFit.cover,
              alignment: Alignment.topLeft,
            ),
          ),
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
              child: Container(
                color: Colors.black.withOpacity(.5),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          height:
                              MediaQuery.of(context).size.height * (1 - 0.49),
                          width: MediaQuery.of(context).size.width,
                          child: CachedNetworkImage(
                            imageUrl: info.posterPath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CreateIcons(
                                  onTap: () => Navigator.pop(context),
                                  child: const Icon(
                                    CupertinoIcons.back,
                                    color: Colors.white,
                                  ),
                                ),
                                CreateIcons(
                                    onTap: () {
                                      showModalBottomSheet<void>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: const Color.fromARGB(
                                            255, 30, 34, 45),
                                        context: context,
                                        builder: (BuildContext ctx) {
                                          return Container(
                                            color: Colors.black26,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const SizedBox(
                                                  height: 14,
                                                ),
                                                Container(
                                                  height: 5,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                Column(
                                                  children: [
                                                    CopyLink(
                                                      title: info.name,
                                                      id: tvId,
                                                      type:
                                                          'season-${info.seasonNumber}',
                                                    ),
                                                    Divider(
                                                      height: .5,
                                                      thickness: .5,
                                                      color:
                                                          Colors.grey.shade800,
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    ListTile(
                                                      onTap: () {
                                                        launch(
                                                            "https://www.themoviedb.org/tv/$tvId/season/" +
                                                                info.seasonNumber
                                                                    .toString());
                                                      },
                                                      leading: Icon(
                                                        CupertinoIcons.share,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                      title: Text(
                                                        "Open in Brower ",
                                                        style:
                                                            normalText.copyWith(
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: .5,
                                                      thickness: .5,
                                                      color:
                                                          Colors.grey.shade800,
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      CupertinoIcons.ellipsis,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    BottomInfoSheet(
                        minSize: .5,
                        child: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: DelayedDisplay(
                                      delay: const Duration(milliseconds: 500),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          boxShadow: kElevationToShadow[4],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          child: CachedNetworkImage(
                                              imageUrl: info.posterPath),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        DelayedDisplay(
                                          delay:
                                              const Duration(microseconds: 700),
                                          child: Text(
                                            info.name,
                                            style: heading.copyWith(
                                                color: textColor, fontSize: 24),
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        DelayedDisplay(
                                          delay:
                                              const Duration(microseconds: 700),
                                          child: RichText(
                                            text: TextSpan(
                                              style: normalText.copyWith(
                                                  color: textColor,
                                                  fontWeight: FontWeight.bold),
                                              children: [
                                                TextSpan(
                                                  text: info.customDate + " | ",
                                                ),
                                                TextSpan(
                                                  text: info.episodes.length
                                                          .toString() +
                                                      " Episodes",
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                DelayedDisplay(
                                    delay: const Duration(microseconds: 800),
                                    child: Text("Overview",
                                        style: heading.copyWith(
                                            color: textColor))),
                                const SizedBox(height: 10),
                                DelayedDisplay(
                                  delay: const Duration(microseconds: 1000),
                                  child: ReadMoreText(
                                    info.overview == "N/A"
                                        ? "${info.name} premiered on " +
                                            info.customDate
                                        : info.overview,
                                    trimLines: 8,
                                    colorClickableText: Colors.pink,
                                    trimMode: TrimMode.Line,
                                    trimCollapsedText: 'Show more',
                                    trimExpandedText: 'Show less',
                                    style: normalText.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: textColor),
                                    moreStyle: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (trailers.isNotEmpty)
                            TrailersWidget(
                              trailers: trailers,
                              backdrops: backdrops,
                              backdrop: backdrop,
                            ),
                          if (castList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text("Cast",
                                      style:
                                          heading.copyWith(color: textColor)),
                                ),
                                CastList(castList: castList),
                              ],
                            ),
                          if (info.episodes.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text("Episodes",
                                      style:
                                          heading.copyWith(color: textColor)),
                                ),
                              ],
                            ),
                          for (var i = 0; i < info.episodes.length; i++)
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20),
                                      ),
                                    ),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    builder: (context) {
                                      return BottomSheet(
                                        builder: (context) => EpisodeInfo(
                                          color: info.posterPath,
                                          model: info.episodes[i],
                                          textColor: textColor,
                                        ),
                                        onClosing: () {},
                                      );
                                    });
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * .8,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey.shade800,
                                            boxShadow: kElevationToShadow[8],
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: 250,
                                              imageUrl:
                                                  info.episodes[i].stillPath,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            child: Container(
                                                color: color,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      info.episodes[i].number,
                                                      style: heading.copyWith(
                                                          color: textColor)),
                                                )))
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: info.episodes[i].name,
                                                  style: heading.copyWith(
                                                      color: textColor,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            info.episodes[i].customDate,
                                            style: heading.copyWith(
                                                color:
                                                    textColor.withOpacity(.8),
                                                fontSize: 18),
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              IconTheme(
                                                data: IconThemeData(
                                                  color:
                                                      textColor == Colors.white
                                                          ? Colors.amber
                                                          : Colors.cyanAccent,
                                                  size: 20,
                                                ),
                                                child: StarDisplay(
                                                  value: ((info.episodes[i]
                                                                  .voteAverage *
                                                              5) /
                                                          10)
                                                      .round(),
                                                ),
                                              ),
                                              Text(
                                                "  " +
                                                    info.episodes[i].voteAverage
                                                        .toString() +
                                                    "/10",
                                                style: normalText.copyWith(
                                                  color:
                                                      textColor == Colors.white
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
                        ],
                        backdrops: info.posterPath)
                  ],
                ),
              ))),
    );
  }
}

class EpisodeInfo extends StatelessWidget {
  final EpisodeModel model;
  final String color;

  final Color textColor;

  const EpisodeInfo({
    Key? key,
    required this.model,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: model.castInfoList.isNotEmpty
          ? MediaQuery.of(context).size.height * .8
          : MediaQuery.of(context).size.height * .7,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(.6),
          image: DecorationImage(
            image: CachedNetworkImageProvider(color),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            color: Colors.black.withOpacity(.6),
            child: ListView(shrinkWrap: true, children: [
              Stack(
                children: [
                  CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: model.stillPath,
                  ),
                  Positioned(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(model.number,
                        style: heading.copyWith(color: textColor)),
                  ))
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
                            text: model.name,
                            style: heading.copyWith(
                                color: textColor, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      model.customDate,
                      style: heading.copyWith(
                          color: textColor.withOpacity(.8), fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    ReadMoreText(
                      model.overview,
                      trimLines: 4,
                      colorClickableText: Colors.pink,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: 'Show less',
                      style: normalText.copyWith(
                          fontWeight: FontWeight.w500, color: textColor),
                      moreStyle: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
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
                            value: ((model.voteAverage * 5) / 10).round(),
                          ),
                        ),
                        Text(
                          "  " + model.voteAverage.toString() + "/10",
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
              ),
              if (model.castInfoList.isNotEmpty ||
                  // ignore: unnecessary_null_comparison
                  model.castInfoList != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("Guest stars",
                          style: heading.copyWith(color: textColor)),
                    ),
                    CastList(
                      castList: model.castInfoList,
                    ),
                  ],
                ),
            ]),
          ),
        ),
      ),
    );
  }
}
