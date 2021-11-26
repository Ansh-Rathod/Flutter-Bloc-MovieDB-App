import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moviedb/animation.dart';
import 'package:readmore/readmore.dart';

import 'package:moviedb/data/fetch_color_palette.dart';
import 'package:moviedb/models/formated_time_genrator.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/screens/movie_info_screen/bloc/movie_info_bloc.dart';
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

import '../../constants.dart';

class MovieDetailsScreen extends StatefulWidget {
  final String id;
  final String backdrop;
  const MovieDetailsScreen({
    Key? key,
    required this.id,
    required this.backdrop,
  }) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late MovieInfoBloc homeBloc;

  @override
  void initState() {
    homeBloc = BlocProvider.of<MovieInfoBloc>(context);
    homeBloc.add(LoadMoviesInfo(id: widget.id));
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
        body: BlocBuilder<MovieInfoBloc, MovieInfoState>(
          builder: (context, state) {
            if (state is MovieInfoLoaded)
              return MovieDetailScreenWidget(
                info: state.tmdbData,
                backdrops: state.backdrops,
                similar: state.similar,
                castList: state.cast,
                color: backgroundColor,
                imdbInfo: state.imdbData,
                trailers: state.trailers,
                textColor: textColor,
                backdrop: widget.backdrop,
              );
            else if (state is MovieInfoError)
              return ErrorPage();
            else if (state is MovieInfoLoading)
              return Loading(
                image: widget.backdrop,
              );

            return Container();
          },
        ),
      ),
    );
  }
}

class MovieDetailScreenWidget extends StatelessWidget {
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final Color textColor;
  final List<MovieModel> similar;
  final Color color;
  const MovieDetailScreenWidget({
    Key? key,
    required this.info,
    required this.imdbInfo,
    required this.backdrops,
    required this.trailers,
    required this.castList,
    required this.backdrop,
    required this.textColor,
    required this.similar,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      duration: Duration(microseconds: 600),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBarWithShadow(
            image: backdrop,
            title: info.title,
            color: color,
            textColor: textColor,
            id: info.tmdbId,
            isMovie: true,
            poster: info.poster,
            releaseDate: info.dateByMonth,
            homepage: info.homepage,
            rate: info.rateing,
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(
                      child:
                          CachedNetworkImage(imageUrl: info.poster, width: 120),
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
                                    text:
                                        " (${info.releaseDate.split("-")[0]})",
                                    style: heading.copyWith(
                                        color: textColor.withOpacity(.8),
                                        fontSize: 18),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          DelayedDisplay(
                            delay: Duration(microseconds: 700),
                            child: Text(
                              imdbInfo.genre,
                              style: normalText.copyWith(color: textColor),
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
              ),
            ),
          ),
          if (info.overview != '')
            SliverToBoxAdapter(
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
                        moreStyle: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
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
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
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
                    ),
                  ),
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
                  HorizontalListViewMovies(list: similar, color: textColor)
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
