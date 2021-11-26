import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/animation.dart';

import 'package:moviedb/data/fetch_color_palette.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/season_details_model.dart';
import 'package:moviedb/screens/cast_info_screen/cast_info_screen.dart';
import 'package:moviedb/screens/season_info_screen/bloc/season_detail_bloc.dart';
import 'package:moviedb/widgets/cast_list.dart';
import 'package:moviedb/widgets/no_results_found.dart';
import 'package:moviedb/widgets/star_icon_display.dart';
import 'package:moviedb/widgets/trailer_widget.dart';
import 'package:readmore/readmore.dart';

import '../../constants.dart';

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
  late SeasonDetailBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<SeasonDetailBloc>(context);
    homeBloc.add(LoadSeasonInfo(id: widget.id, snum: widget.snum));
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
        body: BlocBuilder<SeasonDetailBloc, SeasonDetailState>(
          builder: (context, state) {
            if (state is SeasonDetailLoaded)
              return SeasonInfoWidget(
                info: state.seasonDetail,
                castList: state.cast,
                textColor: textColor,
                color: backgroundColor,
                backdrop: widget.backdrop,
                trailers: state.trailers,
                backdrops: state.backdrops,
              );
            else if (state is SeasonDetailError)
              return ErrorPage();
            else if (state is SeasonDetailLoading)
              return Container(
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.cyanAccent,
                )),
              );

            return Container();
          },
        ),
      ),
    );
  }
}

class SeasonInfoWidget extends StatelessWidget {
  final SeasonModel info;
  final List<CastInfo> castList;
  final Color color;
  final String backdrop;

  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final Color textColor;
  const SeasonInfoWidget({
    Key? key,
    required this.info,
    required this.castList,
    required this.color,
    required this.backdrop,
    required this.backdrops,
    required this.trailers,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      duration: Duration(microseconds: 1000),
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
                  DelayedDisplay(
                    delay: Duration(microseconds: 600),
                    child: Text(
                      info.name,
                      style: heading.copyWith(color: textColor, fontSize: 24),
                    ),
                  ),
                  SizedBox(height: 5),
                  DelayedDisplay(
                    delay: Duration(microseconds: 600),
                    child: RichText(
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
                  DelayedDisplay(
                      delay: Duration(microseconds: 700),
                      child: Text("Overview",
                          style: heading.copyWith(color: textColor))),
                  SizedBox(height: 10),
                  DelayedDisplay(
                    delay: Duration(microseconds: 800),
                    child: ReadMoreText(
                      info.overview == "N/A"
                          ? "${info.name} premiered on " + info.customDate
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

class EpisodeInfo extends StatelessWidget {
  final EpisodeModel model;
  final Color color;

  final Color textColor;

  const EpisodeInfo({
    Key? key,
    required this.model,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: model.castInfoList.isNotEmpty
          ? MediaQuery.of(context).size.height * .8
          : MediaQuery.of(context).size.height * .7,
      color: color,
      child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            Stack(
              children: [
                Container(
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: model.stillPath,
                  ),
                ),
                Positioned(
                    child: Container(
                        color: color,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(model.number,
                              style: heading.copyWith(color: textColor)),
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
                          text: model.name,
                          style:
                              heading.copyWith(color: textColor, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    model.customDate,
                    style: heading.copyWith(
                        color: textColor.withOpacity(.8), fontSize: 18),
                  ),
                  SizedBox(height: 5),
                  ReadMoreText(
                    model.overview,
                    trimLines: 4,
                    colorClickableText: Colors.pink,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Show more',
                    trimExpandedText: 'Show less',
                    style: normalText.copyWith(
                        fontWeight: FontWeight.w500, color: textColor),
                    moreStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
            if (model.castInfoList.isNotEmpty || model.castInfoList != null)
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("Guest stars",
                          style: heading.copyWith(color: textColor)),
                    ),
                    CastList(
                        castList: model.castInfoList, textColor: textColor),
                  ],
                ),
              ),
          ]),
    );
  }
}
