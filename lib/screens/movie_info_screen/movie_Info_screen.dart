// ignore_for_file: file_names

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
import '../../widgets/app_bar.dart';
import '../../widgets/cast_list.dart';
import '../../widgets/draggable_sheet.dart';
import '../../widgets/expandable_group.dart';
import '../../widgets/horizontal_list_cards.dart';
import '../../widgets/like_button/like_button.dart';
import '../../widgets/no_results_found.dart';
import '../../widgets/star_icon_display.dart';
import '../../widgets/trailer_widget.dart';
import 'bloc/movie_info_bloc.dart';

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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieInfoBloc()..add(LoadMoviesInfo(id: widget.id)),
      child: BlocBuilder<MovieInfoBloc, MovieInfoState>(
        builder: (context, state) {
          if (state is MovieInfoLoaded) {
            return MovieDetailScreenWidget(
              info: state.tmdbData,
              backdrops: state.backdrops,
              similar: state.similar,
              castList: state.cast,
              imdbInfo: state.imdbData,
              trailers: state.trailers,
              backdrop: widget.backdrop,
            );
          } else if (state is MovieInfoError) {
            return const ErrorPage();
          } else if (state is MovieInfoLoading) {
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

class MovieDetailScreenWidget extends StatelessWidget {
  final MovieInfoModel info;
  final MovieInfoImdb imdbInfo;
  final List<ImageBackdrop> backdrops;
  final List<TrailerModel> trailers;
  final List<CastInfo> castList;
  final String backdrop;
  final List<MovieModel> similar;
  const MovieDetailScreenWidget({
    Key? key,
    required this.info,
    required this.imdbInfo,
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
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
          child: Container(
            color: Colors.black.withOpacity(.5),
            child: Stack(
              // physics: BouncingScrollPhysics(),
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
                                                      "https://www.themoviedb.org/movie/" +
                                                          info.tmdbId);
                                                },
                                                leading: Icon(
                                                  CupertinoIcons.share,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: DelayedDisplay(
                              delay: const Duration(microseconds: 500),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: kElevationToShadow[8],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                      imageUrl: info.poster, width: 120),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
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
                                            style:
                                                heading.copyWith(fontSize: 22),
                                          ),
                                          TextSpan(
                                            text:
                                                " (${info.releaseDate.split("-")[0]})",
                                            style: heading.copyWith(
                                              color:
                                                  Colors.white.withOpacity(.8),
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
                                    child: Text(
                                      imdbInfo.genre,
                                      style: normalText.copyWith(
                                          color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 700),
                                    child: Row(
                                      children: [
                                        IconTheme(
                                          data: const IconThemeData(
                                            color: Colors.amber,
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
                                            color: Colors.amber,
                                            letterSpacing: 1.2,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  DelayedDisplay(
                                    delay: const Duration(microseconds: 800),
                                    child: LikeButton(
                                      id: info.tmdbId,
                                      title: info.title,
                                      rate: info.rateing,
                                      poster: info.poster,
                                      type: 'MOVIE',
                                      date: info.releaseDate,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (info.overview != '')
                      Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DelayedDisplay(
                                delay: const Duration(microseconds: 800),
                                child: Text("Overview",
                                    style:
                                        heading.copyWith(color: Colors.white))),
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
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                                moreStyle: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
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
                          CastList(
                            castList: castList,
                          ),
                        ],
                      ),
                    ExpandableGroup(
                      isExpanded: true,
                      expandedIcon: Icon(
                        Icons.arrow_drop_up,
                        color: Colors.white != Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      collapsedIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white != Colors.white
                            ? Colors.black
                            : Colors.white,
                      ),
                      header: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Text(
                          "About Movie",
                          style: heading.copyWith(color: Colors.white),
                        ),
                      ),
                      items: [
                        ListTile(
                            title: Text(
                              "Runtime",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.runtime,
                              style: normalText.copyWith(color: Colors.white),
                            )),
                        ListTile(
                            title: Text(
                              "Writers",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.writer,
                              style: normalText.copyWith(color: Colors.white),
                            )),
                        ListTile(
                            title: Text(
                              "Director",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.director,
                              style: normalText.copyWith(color: Colors.white),
                            )),
                        ListTile(
                            title: Text(
                              "Released on/Releasing on",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.released,
                              style: normalText.copyWith(color: Colors.white),
                            )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ExpandableGroup(
                        isExpanded: false,
                        expandedIcon: Icon(
                          Icons.arrow_drop_up,
                          color: Colors.white != Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                        collapsedIcon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white != Colors.white
                              ? Colors.black
                              : Colors.white,
                        ),
                        header: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          child: Text(
                            "Movie on Boxoffice",
                            style: heading.copyWith(color: Colors.white),
                          ),
                        ),
                        items: [
                          ListTile(
                              title: Text(
                                "Rated",
                                style: heading.copyWith(
                                    color: Colors.white, fontSize: 16),
                              ),
                              subtitle: Text(
                                imdbInfo.rated,
                                style: normalText.copyWith(color: Colors.white),
                              )),
                          ListTile(
                              title: Text(
                                "Budget",
                                style: heading.copyWith(
                                    color: Colors.white, fontSize: 16),
                              ),
                              subtitle: Text(
                                k_m_b_generator(info.budget) == "0"
                                    ? "N/A"
                                    : k_m_b_generator(info.budget),
                                style: normalText.copyWith(color: Colors.white),
                              )),
                          ListTile(
                            title: Text(
                              "BoxOffice",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 16),
                            ),
                            subtitle: Text(
                              imdbInfo.boxOffice,
                              style: normalText.copyWith(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          HorizontalListViewMovies(
                              list: similar, color: Colors.white)
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

  // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
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

class CreateIcons extends StatelessWidget {
  final Widget child;
  final Function()? onTap;
  const CreateIcons({
    Key? key,
    required this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: kElevationToShadow[2],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 50),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(.5),
            ),
            child: InkWell(onTap: onTap, child: child),
          ),
        ),
      ),
    );
  }
}
