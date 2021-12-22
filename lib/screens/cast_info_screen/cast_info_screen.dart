import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';
import '../../constants.dart';
import '../../models/cast_info_model.dart';
import '../../models/movie_model.dart';
import '../../models/tv_model.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/draggable_sheet.dart';
import '../../widgets/horizontal_list_cards.dart';
import '../../widgets/image_view.dart';
import '../../widgets/no_results_found.dart';
import '../movie_info_screen/movie_Info_screen.dart';
import 'bloc/castinfo_bloc.dart';

class CastInFoScreen extends StatefulWidget {
  final String id;
  final String backdrop;
  const CastInFoScreen({
    Key? key,
    required this.id,
    required this.backdrop,
  }) : super(key: key);

  @override
  _CastInFoScreenState createState() => _CastInFoScreenState();
}

class _CastInFoScreenState extends State<CastInFoScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CastinfoBloc()..add(LoadCastInfo(id: widget.id)),
      child: BlocBuilder<CastinfoBloc, CastinfoState>(
        builder: (context, state) {
          if (state is CastinfoLoaded) {
            return CastScreenWidget(
              movies: state.movies,
              backgroundImage: widget.backdrop,
              tv: state.tvShows,
              info: state.info,
              images: state.images,
              sinfo: state.socialInfo,
            );
          } else if (state is CastinfoError) {
            return const ErrorPage();
          } else if (state is CastinfoLoading) {
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

class CastScreenWidget extends StatelessWidget {
  final CastPersonalInfo info;
  final String backgroundImage;
  final List<TvModel> tv;
  final SocialMediaInfo sinfo;
  final List<MovieModel> movies;
  final List<ImageBackdrop> images;
  const CastScreenWidget({
    Key? key,
    required this.info,
    required this.backgroundImage,
    required this.tv,
    required this.sinfo,
    required this.movies,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(backgroundImage),
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
                      height: MediaQuery.of(context).size.height * (1 - 0.48),
                      width: MediaQuery.of(context).size.width,
                      child: CachedNetworkImage(
                        imageUrl: info.image,
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
                                                title: info.name,
                                                id: info.id,
                                                type: 'cast',
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
                                                      "https://www.themoviedb.org/person/" +
                                                          info.id);
                                                },
                                                leading: Icon(
                                                  CupertinoIcons.share,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                title: Text(
                                                  "Open in Brower",
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
                    ),
                    Positioned(
                        bottom: 30,
                        child: DelayedDisplay(
                          delay: const Duration(microseconds: 800),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              info.name,
                              textAlign: TextAlign.center,
                              style: heading.copyWith(
                                fontSize: 34,
                                shadows: kElevationToShadow[8],
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
                BottomInfoSheet(
                  minSize: .50,
                  child: [
                    IconTheme(
                      data: const IconThemeData(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12),
                        child: DelayedDisplay(
                          slidingBeginOffset: const Offset(0, 0.2),
                          delay: const Duration(microseconds: 700),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (sinfo.facebook != "")
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.facebookSquare,
                                      size: 40),
                                  onPressed: () {
                                    launch(sinfo.facebook);
                                  },
                                ),
                              if (sinfo.twitter != "")
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.twitterSquare,
                                      size: 40),
                                  onPressed: () {
                                    launch(sinfo.twitter);
                                  },
                                ),
                              if (sinfo.instagram != "")
                                IconButton(
                                  icon: const FaIcon(
                                      FontAwesomeIcons.instagramSquare,
                                      size: 40),
                                  onPressed: () {
                                    launch(sinfo.instagram);
                                  },
                                ),
                              if (sinfo.imdbId != "")
                                IconButton(
                                  icon: const FaIcon(FontAwesomeIcons.imdb,
                                      size: 40),
                                  onPressed: () {
                                    launch(sinfo.imdbId);
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12),
                      child: DelayedDisplay(
                        delay: const Duration(microseconds: 800),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Personal Info",
                              style: heading.copyWith(
                                  color: Colors.white, fontSize: 22),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Known for",
                                          style: heading.copyWith(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Text(info.knownfor,
                                            style: normalText.copyWith(
                                              color: Colors.white,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Gender",
                                        style: heading.copyWith(
                                            color: Colors.white, fontSize: 16),
                                      ),
                                      Text(
                                        info.gender,
                                        style: normalText.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Birthday",
                                  style: heading.copyWith(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(info.birthday + " (${info.old})",
                                    style: normalText.copyWith(
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Place of Birth",
                                  style: heading.copyWith(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(info.placeOfBirth,
                                    style: normalText.copyWith(
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (images.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          DelayedDisplay(
                            delay: const Duration(microseconds: 900),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text("Images of " + info.name,
                                  style: heading.copyWith(color: Colors.white)),
                            ),
                          ),
                          DelayedDisplay(
                            delay: const Duration(microseconds: 1100),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  for (var i = 0; i < images.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          pushNewScreen(
                                            context,
                                            ViewPhotos(
                                              imageList: images,
                                              imageIndex: i,
                                              color: Colors.white,
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Container(
                                            height: 200,
                                            color: Colors.black,
                                            width: 130,
                                            child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl: images[i].image),
                                          ),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (info.bio != "")
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Biography",
                              style: heading.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ReadMoreText(
                              info.bio,
                              trimLines: 10,
                              colorClickableText: Colors.pink,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Show more',
                              trimExpandedText: 'Show less',
                              style: normalText.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                              moreStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    if (movies.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("Movies",
                                style: heading.copyWith(color: Colors.white)),
                          ),
                          HorizontalListViewMovies(
                              list: movies, color: Colors.white)
                        ],
                      ),
                    if (tv.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("Tv Shows",
                                style: heading.copyWith(color: Colors.white)),
                          ),
                          HorizontalListViewTv(
                            list: tv,
                            color: Colors.white,
                          )
                        ],
                      ),
                    if (tv.isNotEmpty) const SizedBox(height: 30)
                  ],
                  backdrops: info.image,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
