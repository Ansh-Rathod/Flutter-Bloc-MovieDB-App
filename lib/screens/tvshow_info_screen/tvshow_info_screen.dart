import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieinfo/widgets/image_view.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';
import '../../constants.dart';
import '../../models/movie_model.dart';
import '../../models/tv_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/cast_list.dart';
import '../../widgets/draggable_sheet.dart';
import '../../widgets/expandable_group.dart';
import '../../widgets/horizontal_list_cards.dart';
import '../../widgets/like_button/like_button.dart';
import '../../widgets/no_results_found.dart';
import '../../widgets/star_icon_display.dart';
import '../../widgets/trailer_widget.dart';
import '../movie_info_screen/movie_Info_screen.dart';
import '../season_info_screen/bloc/season_detail_bloc.dart';
import '../season_info_screen/season_details_screen.dart';
import 'bloc/tv_show_detail_bloc.dart';

class TvShowDetailScreen extends StatefulWidget {
  final String id;
  final String backdrop;
  const TvShowDetailScreen({
    Key? key,
    required this.id,
    required this.backdrop,
  }) : super(key: key);

  @override
  _TvShowDetailScreenState createState() => _TvShowDetailScreenState();
}

class _TvShowDetailScreenState extends State<TvShowDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TvShowDetailBloc()..add(LoadTvInfo(id: widget.id)),
      child: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
        builder: (context, state) {
          if (state is TvShowDetailLoaded) {
            return TvInfoScrollableWidget(
              info: state.tmdbData,
              backdrops: state.backdrops,
              similar: state.similar,
              castList: state.cast,
              trailers: state.trailers,
              backdrop: widget.backdrop,
            );
          } else if (state is TvShowDetailError) {
            return const ErrorPage();
          } else if (state is TvShowDetailLoading) {
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

class TvInfoScrollableWidget extends StatelessWidget {
  final TvInfoModel info;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final List<TvModel> similar;
  const TvInfoScrollableWidget({
    Key? key,
    required this.info,
    required this.backdrops,
    required this.trailers,
    required this.castList,
    required this.backdrop,
    required this.similar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(info.poster),
            fit: BoxFit.cover,
            alignment: Alignment.topLeft,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
          child: Container(
            color: Colors.black.withOpacity(.9),
            child: Stack(
              children: [
                Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          ViewPhotos(
                            imageIndex: 0,
                            color: Theme.of(context).primaryColor,
                            imageList: backdrops,
                          ),
                        );
                      },
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * (1 - 0.63),
                        width: MediaQuery.of(context).size.width,
                        child: CachedNetworkImage(
                          imageUrl: info.backdrops,
                          fit: BoxFit.cover,
                        ),
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
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  backgroundColor:
                                      const Color.fromARGB(255, 30, 34, 45),
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
                                                  BorderRadius.circular(20),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Column(
                                            children: [
                                              CopyLink(
                                                title: info.title,
                                                id: info.tmdbId,
                                                type: 'movie',
                                              ),
                                              Divider(
                                                height: .5,
                                                thickness: .5,
                                                color: Colors.grey.shade800,
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  launch(
                                                      "https://www.themoviedb.org/tv/" +
                                                          info.tmdbId);
                                                },
                                                leading: Icon(
                                                  CupertinoIcons.photo,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Open in Brower ",
                                                  style: normalText.copyWith(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              Divider(
                                                height: .5,
                                                thickness: .5,
                                                color: Colors.grey.shade800,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                BottomInfoSheet(
                  backdrops: info.backdrops,
                  child: [
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: DelayedDisplay(
                                  delay: const Duration(milliseconds: 500),
                                  child: Container(
                                    width: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.grey.shade900,
                                      boxShadow: kElevationToShadow[8],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: info.poster,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    DelayedDisplay(
                                      delay: const Duration(microseconds: 700),
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: info.title,
                                              style: heading.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 22),
                                            ),
                                            TextSpan(
                                              text:
                                                  " (${info.date.split("-")[0]})",
                                              style: heading.copyWith(
                                                color: Colors.white
                                                    .withOpacity(.8),
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    DelayedDisplay(
                                      delay: const Duration(microseconds: 700),
                                      child: RichText(
                                        text: TextSpan(
                                          style: normalText.copyWith(
                                              color: Colors.white),
                                          children: [
                                            ...info.genres
                                                .map(
                                                  (genre) => TextSpan(
                                                      text: "$genre, "),
                                                )
                                                .toList()
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    DelayedDisplay(
                                      delay: const Duration(microseconds: 700),
                                      child: Row(
                                        children: [
                                          IconTheme(
                                            data: IconThemeData(
                                              color:
                                                  Colors.white == Colors.white
                                                      ? Colors.amber
                                                      : Colors.blue,
                                              size: 20,
                                            ),
                                            child: StarDisplay(
                                              value: ((info.rateing * 5) / 10)
                                                  .round(),
                                            ),
                                          ),
                                          Text(
                                            "  " +
                                                info.rateing.toString() +
                                                "/10",
                                            style: normalText.copyWith(
                                              color:
                                                  Colors.white == Colors.white
                                                      ? Colors.amber
                                                      : Colors.blue,
                                              letterSpacing: 1.2,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    DelayedDisplay(
                                      delay: const Duration(milliseconds: 900),
                                      child: LikeButton(
                                        id: info.tmdbId,
                                        title: info.title,
                                        rate: info.rateing,
                                        poster: info.poster,
                                        type: 'TV',
                                        date: info.date,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                    if (info.overview != '')
                      OverviewWidget(textColor: Colors.white, info: info),
                    if (trailers.isNotEmpty)
                      TrailersWidget(
                        trailers: trailers,
                        backdrops: backdrops,
                        backdrop: info.backdrops,
                      ),
                    if (castList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("Cast",
                                style: heading.copyWith(color: Colors.white)),
                          ),
                          CastList(castList: castList),
                        ],
                      ),
                    AboutShowWidget(textColor: Colors.white, info: info),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: Text("Seasons",
                          style: heading.copyWith(color: Colors.white)),
                    ),
                    ...info.seasons
                        .map((season) => SeasonsWidget(
                              info: info,
                              textColor: Colors.white,
                              season: season,
                            ))
                        .toList(),
                    if (similar.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("You might also like",
                                style: heading.copyWith(color: Colors.white)),
                          ),
                          HorizontalListViewTv(list: similar)
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AboutShowWidget extends StatelessWidget {
  const AboutShowWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: ExpandableGroup(
        isExpanded: true,
        expandedIcon: Icon(
          Icons.arrow_drop_up,
          color: Colors.white != Colors.white ? Colors.black : Colors.white,
        ),
        collapsedIcon: Icon(
          Icons.arrow_drop_down,
          color: Colors.white != Colors.white ? Colors.black : Colors.white,
        ),
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            "About Show",
            style: heading.copyWith(color: Colors.white),
          ),
        ),
        items: [
          if (info.created.isNotEmpty)
            ListTile(
              title: Text(
                "Created By",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: [
                    ...info.created
                        .map(
                          (genre) => TextSpan(text: "$genre, "),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          if (info.networks.isNotEmpty)
            ListTile(
              title: Text(
                "Avalable on",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: [
                    ...info.networks
                        .map(
                          (genre) => TextSpan(text: "$genre, "),
                        )
                        .toList()
                  ],
                ),
              ),
            ),
          ListTile(
              title: Text(
                "Number Of Seasons",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                info.numberOfSeasons,
                style: normalText.copyWith(color: Colors.white),
              )),
          ListTile(
              title: Text(
                "Episode Run Time",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                info.episoderuntime,
                style: normalText.copyWith(color: Colors.white),
              )),
          if (info.formatedDate != "")
            ListTile(
              title: Text(
                "First Episode Released on",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: RichText(
                text: TextSpan(
                  style: normalText.copyWith(color: Colors.white),
                  children: [
                    TextSpan(text: info.formatedDate),
                  ],
                ),
              ),
            ),
          if (info.tagline != "")
            ListTile(
              title: Text(
                "Show Tagline",
                style: heading.copyWith(color: Colors.white, fontSize: 16),
              ),
              subtitle: Text(
                info.tagline,
                style: normalText.copyWith(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}

class SeasonsWidget extends StatelessWidget {
  const SeasonsWidget({
    Key? key,
    required this.info,
    required this.season,
    required this.textColor,
  }) : super(key: key);

  final TvInfoModel info;
  final Seasons season;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pushNewScreen(
          context,
          BlocProvider(
            create: (context) => SeasonDetailBloc(),
            child: SeasonDetailScreen(
              backdrop: season.image,
              id: info.tmdbId,
              snum: season.snum,
            ),
          ),
        );
      },
      child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: kElevationToShadow[4],
                    ),
                    child: CachedNetworkImage(
                      imageUrl: season.image,
                      width: 180,
                      fit: BoxFit.contain,
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
                      Text(
                        season.name,
                        style:
                            heading.copyWith(color: Colors.white, fontSize: 24),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: normalText.copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: season.date.split("-")[0] + " | ",
                            ),
                            TextSpan(
                              text: season.episodes + " Episodes",
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const SizedBox(height: 5),
                      ReadMoreText(
                        season.overview == "N/A"
                            ? "${season.name} of ${info.title} " +
                                season.customOverView
                            : season.overview,
                        trimLines: 4,
                        colorClickableText: Colors.pink,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: normalText.copyWith(
                            fontWeight: FontWeight.w500, color: Colors.white),
                        moreStyle: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class OverviewWidget extends StatelessWidget {
  const OverviewWidget({
    Key? key,
    required this.textColor,
    required this.info,
  }) : super(key: key);

  final Color textColor;
  final TvInfoModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DelayedDisplay(
              delay: const Duration(microseconds: 800),
              child: Text("Overview",
                  style: heading.copyWith(color: Colors.white))),
          const SizedBox(height: 10),
          DelayedDisplay(
            delay: const Duration(microseconds: 1000),
            child: ReadMoreText(
              info.overview,
              trimLines: 6,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'more',
              trimExpandedText: 'less',
              style: normalText.copyWith(
                  fontWeight: FontWeight.w500, color: Colors.white),
              moreStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
