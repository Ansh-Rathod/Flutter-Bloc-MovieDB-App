import 'package:amd/widgets/Error_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:amd/models/cast_info.dart';
import 'package:amd/models/movie_info_model.dart';
import 'package:amd/models/movie_model.dart';
import 'package:amd/models/tv_model.dart';
import 'package:amd/screeens/home/home.dart';
import 'package:amd/themes.dart';
import 'package:amd/widgets/image_view.dart';
import 'package:amd/widgets/loading.dart';
import 'package:amd/widgets/star_icon.dart';

import 'bloc/cast_movies_bloc.dart';

class CastPersonalInfoScreen extends StatelessWidget {
  final String image;
  final String title;

  const CastPersonalInfoScreen({
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
        body: BlocBuilder<CastMoviesBloc, CastMoviesState>(
          builder: (context, state) {
            if (state is CastMoviesLoading) {
              return LoadingCast(
                image: image,
                title: title,
              );
            } else if (state is CastMoviesLoaded) {
              return CastInfoLoaded(
                color: state.color,
                movies: state.movies,
                backgroundImage: image,
                tv: state.tvShows,
                info: state.info,
                images: state.images,
                sinfo: state.socialInfo,
                textColor: state.textColor,
              );
            } else if (state is CastMoviesError) {
              return ErrorPage();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

class CastInfoLoaded extends StatelessWidget {
  final CastPersonalInfo info;
  final String backgroundImage;
  final Color color;
  final List<TvModel> tv;
  final Color textColor;
  final SocialMediaInfo sinfo;
  final List<MovieModel> movies;
  final List<ImageBackdrop> images;
  const CastInfoLoaded({
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
    return Container(
      color: color,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (sinfo.facebook != "")
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebookSquare, size: 40),
                        onPressed: () {
                          launch(sinfo.facebook);
                        },
                      ),
                    if (sinfo.twitter != "")
                      IconButton(
                        icon: FaIcon(FontAwesomeIcons.twitterSquare, size: 40),
                        onPressed: () {
                          launch(sinfo.twitter);
                        },
                      ),
                    if (sinfo.instagram != "")
                      IconButton(
                        icon:
                            FaIcon(FontAwesomeIcons.instagramSquare, size: 40),
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
          SliverToBoxAdapter(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
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
          )),
          if (images.isNotEmpty)
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text("Images of " + info.name,
                        style: heading.copyWith(color: textColor)),
                  ),
                  SingleChildScrollView(
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
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < movies.length; i++)
                          MoviePoster(
                              isMovie: true,
                              id: movies[i].id,
                              name: movies[i].title,
                              backdrop: movies[i].backdrop,
                              poster: movies[i].poster,
                              color: textColor,
                              date: movies[i].release_date)
                      ],
                    ),
                  ),
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
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var i = 0; i < tv.length; i++)
                          MoviePoster(
                            isMovie: false,
                            id: tv[i].id,
                            name: tv[i].title,
                            backdrop: tv[i].backdrop,
                            poster: tv[i].poster,
                            color: textColor,
                            date: tv[i].release_date,
                          )
                      ],
                    ),
                  ),
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
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return SliverAppBar(
        pinned: true,
        stretch: true,
        brightness:
            textColor == Colors.black ? Brightness.light : Brightness.dark,
        elevation: 0,
        backgroundColor: color,
        expandedHeight: 400,
        leading: IconButton(
          icon: DecoratedIcon(
            Icons.arrow_back_sharp,
            color: textColor,
            size: 30.0,
            shadows: [
              BoxShadow(
                blurRadius: 92.0,
                color: color,
              ),
              BoxShadow(
                blurRadius: 12.0,
                color: color,
              ),
            ],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewPhotos(
                    imageList: [
                      ImageBackdrop(image: image),
                    ],
                    imageIndex: 0,
                    color: color,
                  ),
                ),
              );
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
