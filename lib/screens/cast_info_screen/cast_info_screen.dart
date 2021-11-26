import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moviedb/constants.dart';

import 'package:moviedb/data/fetch_color_palette.dart';
import 'package:moviedb/models/cast_info_model.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/models/tv_model.dart';
import 'package:moviedb/screens/cast_info_screen/bloc/castinfo_bloc.dart';
import 'package:moviedb/widgets/horizontal_list_cards.dart';
import 'package:moviedb/widgets/image_view.dart';
import 'package:moviedb/widgets/no_results_found.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../animation.dart';

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
  late CastinfoBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<CastinfoBloc>(context);
    bloc.add(LoadCastInfo(id: widget.id));
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
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<CastinfoBloc, CastinfoState>(
          builder: (context, state) {
            if (state is CastinfoLoaded)
              return CastScreenWidget(
                color: backgroundColor,
                movies: state.movies,
                backgroundImage: widget.backdrop,
                tv: state.tvShows,
                info: state.info,
                images: state.images,
                sinfo: state.socialInfo,
                textColor: textColor,
              );
            else if (state is CastinfoError)
              return ErrorPage();
            else if (state is CastinfoLoading)
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

class CastScreenWidget extends StatelessWidget {
  final CastPersonalInfo info;
  final String backgroundImage;
  final Color color;
  final List<TvModel> tv;
  final Color textColor;
  final SocialMediaInfo sinfo;
  final List<MovieModel> movies;
  final List<ImageBackdrop> images;
  const CastScreenWidget({
    Key? key,
    required this.info,
    required this.backgroundImage,
    required this.color,
    required this.tv,
    required this.textColor,
    required this.sinfo,
    required this.movies,
    required this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: color,
      duration: Duration(microseconds: 1000),
      child: CustomScrollView(
        physics: BouncingScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBarCast(
            color: color,
            textColor: textColor,
            title: info.name,
            image: backgroundImage,
          ),
          SliverToBoxAdapter(
            child: IconTheme(
              data: IconThemeData(
                color: textColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: DelayedDisplay(
                  delay: Duration(microseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (sinfo.facebook != "")
                        IconButton(
                          icon:
                              FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                          onPressed: () {
                            launch(sinfo.facebook);
                          },
                        ),
                      if (sinfo.twitter != "")
                        IconButton(
                          icon:
                              FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                          onPressed: () {
                            launch(sinfo.twitter);
                          },
                        ),
                      if (sinfo.instagram != "")
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.instagramSquare,
                              size: 40),
                          onPressed: () {
                            launch(sinfo.instagram);
                          },
                        ),
                      if (sinfo.imdbId != "")
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.imdb, size: 40),
                          onPressed: () {
                            launch(sinfo.imdbId);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
            child: DelayedDisplay(
              delay: Duration(microseconds: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Personal Info",
                    style: heading.copyWith(color: textColor, fontSize: 22),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * .5,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Known for",
                                style: heading.copyWith(
                                    color: textColor, fontSize: 16),
                              ),
                              Text(info.knownfor,
                                  style: normalText.copyWith(
                                    color: textColor,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: heading.copyWith(
                                  color: textColor, fontSize: 16),
                            ),
                            Text(info.gender,
                                style: normalText.copyWith(
                                  color: textColor,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Birthday",
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      Text(info.birthday + " (${info.old})",
                          style: normalText.copyWith(
                            color: textColor,
                          )),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Place of Birth",
                        style: heading.copyWith(color: textColor, fontSize: 16),
                      ),
                      Text(info.placeOfBirth,
                          style: normalText.copyWith(
                            color: textColor,
                          )),
                    ],
                  ),
                ],
              ),
            ),
          )),
          if (images.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  DelayedDisplay(
                    delay: Duration(microseconds: 900),
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text("Images of " + info.name,
                          style: heading.copyWith(color: textColor)),
                    ),
                  ),
                  DelayedDisplay(
                    delay: Duration(microseconds: 1100),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var i = 0; i < images.length; i++)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewPhotos(
                                        imageList: images,
                                        imageIndex: i,
                                        color: color,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 200,
                                  color: Colors.black,
                                  width: 130,
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl: images[i].image),
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (info.bio != "")
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Biography",
                      style: heading.copyWith(
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    ReadMoreText(
                      info.bio,
                      trimLines: 10,
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
          if (movies.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Movies",
                        style: heading.copyWith(color: textColor)),
                  ),
                  HorizontalListViewMovies(list: movies, color: textColor)
                ],
              ),
            ),
          if (movies.isNotEmpty)
            SliverToBoxAdapter(child: SizedBox(height: 10)),
          if (tv.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Tv Shows",
                        style: heading.copyWith(color: textColor)),
                  ),
                  HorizontalListViewTv(
                    list: tv,
                    color: textColor,
                  )
                ],
              ),
            ),
          if (tv.isNotEmpty) SliverToBoxAdapter(child: SizedBox(height: 30))
        ],
      ),
    );
  }
}

class SliverAppBarCast extends StatelessWidget {
  const SliverAppBarCast({
    Key? key,
    required this.textColor,
    required this.title,
    required this.image,
    required this.color,
  }) : super(key: key);
  final Color textColor;
  final String title;
  final String image;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        pinned: true,
        stretch: true,
        brightness:
            textColor == Colors.black ? Brightness.light : Brightness.dark,
        elevation: 0,
        backgroundColor: color,
        expandedHeight: 400,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_sharp,
            color: textColor,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: IconThemeData(color: textColor),
        flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
          centerTitle: true,
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          background: InkWell(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => ViewPhotos(
              //       imageList: [
              //         ImageBackdrop(image: image),
              //       ],
              //       imageIndex: 0,
              //       color: color,
              //     ),
              //   ),
              // );
            },
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.center,
                  begin: Alignment.bottomCenter,
                  colors: [
                    color,
                    color.withOpacity(.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 300,
                decoration: BoxDecoration(
                  color: color,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      image,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
