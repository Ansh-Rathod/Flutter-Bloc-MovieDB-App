import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/animation.dart';
import 'package:readmore/readmore.dart';

import 'package:moviedb/constants.dart';
import 'package:moviedb/data/fetch_color_palette.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';
import 'package:moviedb/screens/season_info_screen/bloc/season_detail_bloc.dart';
import 'package:moviedb/screens/season_info_screen/season_details_screen.dart';
import 'package:moviedb/screens/tvshow_info_screen/bloc/tv_show_detail_bloc.dart';
import 'package:moviedb/widgets/app_bar.dart';
import 'package:moviedb/widgets/cast_list.dart';
import 'package:moviedb/widgets/expandable_group.dart';
import 'package:moviedb/widgets/horizontal_list_cards.dart';
import 'package:moviedb/widgets/like_button/cubit/like_movie_cubit.dart';
import 'package:moviedb/widgets/like_button/fav_button.dart';
import 'package:moviedb/widgets/loading.dart';
import 'package:moviedb/widgets/no_results_found.dart';
import 'package:moviedb/widgets/star_icon_display.dart';
import 'package:moviedb/widgets/trailer_widget.dart';

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
  late TvShowDetailBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<TvShowDetailBloc>(context);
    homeBloc.add(LoadTvInfo(id: widget.id));
    getColor();
    super.initState();
  }

  final ColorGenrator color = ColorGenrator();
  Color backgroundColor = Colors.black;
  Color textColor = Colors.white;
  getColor() async {
    List<Color> colors =
        await color.getImagePalette(Image.network(widget.backdrop).image);
    setState(() {
      backgroundColor = colors[0];
      textColor = colors[1];
    });
  }

  @override
  void dispose() {
    homeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<TvShowDetailBloc, TvShowDetailState>(
          builder: (context, state) {
            if (state is TvShowDetailLoaded)
              return TvInfoScrollableWidget(
                info: state.tmdbData,
                backdrops: state.backdrops,
                similar: state.similar,
                castList: state.cast,
                color: backgroundColor,
                trailers: state.trailers,
                textColor: textColor,
                backdrop: widget.backdrop,
              );
            else if (state is TvShowDetailError)
              return ErrorPage();
            else if (state is TvShowDetailLoading)
              return Loading(image: widget.backdrop);

            return Container();
          },
        ),
      ),
    );
  }
}

class TvInfoScrollableWidget extends StatelessWidget {
  final TvInfoModel info;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final Color textColor;
  final String backdrop;
  final List<TvModel> similar;
  final Color color;
  TvInfoScrollableWidget({
    Key? key,
    required this.info,
    required this.backdrops,
    required this.trailers,
    required this.castList,
    required this.textColor,
    required this.backdrop,
    required this.similar,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      duration: Duration(microseconds: 1000),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBarWithShadow(
            image: backdrop,
            title: info.title,
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
                      child: Container(
                        width: 120,
                        child: CachedNetworkImage(
                          imageUrl: info.poster,
                          fit: BoxFit.cover,
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
                            DelayedDisplay(
                              delay: Duration(microseconds: 700),
                              child: RichText(
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
                            ),
                            SizedBox(height: 5),
                            DelayedDisplay(
                              delay: Duration(microseconds: 700),
                              child: RichText(
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
                            ),
                            SizedBox(height: 5),
                            DelayedDisplay(
                              delay: Duration(microseconds: 700),
                              child: Row(
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
                  HorizontalListViewTv(list: similar)
                ],
              ),
            ),
          SliverToBoxAdapter(child: SizedBox(height: 30))
        ],
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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 12.0),
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
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "About Show",
              style: heading.copyWith(color: textColor),
            ),
          ),
          items: [
            if (info.created.isNotEmpty)
              ListTile(
                title: Text(
                  "Created By",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
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
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
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
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.numberOfSeasons,
                  style: normalText.copyWith(color: textColor),
                )),
            ListTile(
                title: Text(
                  "Episode Run Time",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.episoderuntime,
                  style: normalText.copyWith(color: textColor),
                )),
            if (info.formatedDate != "")
              ListTile(
                title: Text(
                  "First Episode Released on",
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: normalText.copyWith(color: textColor),
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
                  style: heading.copyWith(color: textColor, fontSize: 16),
                ),
                subtitle: Text(
                  info.tagline,
                  style: normalText.copyWith(color: textColor),
                ),
              )
          ],
        ),
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
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SeasonDetailBloc(),
                child: SeasonDetailScreen(
                  backdrop: season.image,
                  id: info.tmdbId,
                  snum: season.snum,
                ),
              ),
            ),
          );
        },
        child: Container(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.black,
                    child: CachedNetworkImage(
                      imageUrl: season.image,
                      height: 200,
                      fit: BoxFit.fitHeight,
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
                              heading.copyWith(color: textColor, fontSize: 24),
                        ),
                        SizedBox(height: 5),
                        RichText(
                          text: TextSpan(
                            style: normalText.copyWith(
                                color: textColor, fontWeight: FontWeight.bold),
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
                        SizedBox(height: 5),
                        SizedBox(height: 5),
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
                              fontWeight: FontWeight.w500, color: textColor),
                          moreStyle: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
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
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DelayedDisplay(
                delay: Duration(microseconds: 800),
                child: Text("Overview",
                    style: heading.copyWith(color: textColor))),
            SizedBox(height: 10),
            DelayedDisplay(
              delay: Duration(microseconds: 1000),
              child: ReadMoreText(
                info.overview,
                trimLines: 6,
                colorClickableText: Colors.pink,
                trimMode: TrimMode.Line,
                trimCollapsedText: 'Show more',
                trimExpandedText: 'Show less',
                style: normalText.copyWith(
                    fontWeight: FontWeight.w500, color: textColor),
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
