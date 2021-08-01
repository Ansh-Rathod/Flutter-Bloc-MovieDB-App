import 'package:google_fonts/google_fonts.dart';

import '../screeens/info_pages/movies_info/movies_info.dart';
import '../themes.dart';
import 'star_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            // stretch: true,
            brightness: Brightness.dark,
            elevation: 0,
            backgroundColor: Colors.grey.shade900,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [],
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.center,
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: ColorFiltered(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade900,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade900.withOpacity(.7),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: Container(
                              height: 190,
                              color: Colors.grey.shade900,
                              width: 130,
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
                                  Container(
                                    width: double.infinity,
                                    height: 30.0,
                                    color: Colors.grey.shade900,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 20.0,
                                    color: Colors.grey.shade900,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                  IconTheme(
                                    data: IconThemeData(
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    child: StarDisplay(
                                      value: 5,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                  Container(
                                    child: Row(children: [
                                      Icon(Icons.favorite, size: 35),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                          width: 100,
                                          height: 15,
                                          color: Colors.grey.shade900)
                                    ]),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          height: 30.0,
                          color: Colors.grey.shade900,
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        Container(
                            height: 100,
                            color: Colors.grey.shade900,
                            width: double.infinity),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingCast extends StatelessWidget {
  const LoadingCast({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            // stretch: true,
            brightness: Brightness.dark,
            elevation: 0,
            backgroundColor: Colors.grey.shade900,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.fadeTitle, StretchMode.zoomBackground],
              centerTitle: true,
              title: Text(
                title,
                style: heading.copyWith(color: Colors.grey.shade900),
              ),
              background: DecoratedBox(
                position: DecorationPosition.foreground,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    end: Alignment.center,
                    begin: Alignment.bottomCenter,
                    colors: [
                      Colors.black,
                      Colors.black.withOpacity(.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: ColorFiltered(
                  child: CachedNetworkImage(
                    imageUrl: image,
                    height: MediaQuery.of(context).size.height,
                    fit: BoxFit.cover,
                  ),
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade900,
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade900,
              highlightColor: Colors.grey.shade900.withOpacity(.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 40, width: 40, color: Colors.grey.shade900),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 40, width: 40, color: Colors.grey.shade900),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 40, width: 40, color: Colors.grey.shade900),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                          height: 40, width: 40, color: Colors.grey.shade900),
                    ],
                  ),
                  SizedBox(height: 10),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 30,
                      color: Colors.grey.shade900,
                      width: 150,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Container(
                      color: Colors.grey.shade900,
                      height: 130,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: 30,
                      color: Colors.grey.shade900,
                      width: 200,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FavoritesLoading extends StatelessWidget {
  const FavoritesLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade900.withOpacity(.7),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Activity",
                  style:
                      heading.copyWith(color: Colors.cyanAccent, fontSize: 26),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchLoading extends StatelessWidget {
  const SearchLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade900.withOpacity(.7),
      child: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Container(
                  color: Colors.grey.shade900,
                  child: Text(
                    "Upcoming Movies",
                    style: heading.copyWith(
                      color: Colors.white.withOpacity(.0),
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    for (var i = 0; i < 10; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          height: 200,
                          width: 130,
                          color: Colors.grey.shade900,
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeLoadingPage extends StatelessWidget {
  const HomeLoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade900.withOpacity(.7),
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 550,
                ),
                Positioned(
                  bottom: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            height: 30,
                            width: 300,
                            color: Colors.grey.shade900),
                        SizedBox(height: 10),
                        Container(
                            height: 20,
                            width: 200,
                            color: Colors.grey.shade900),
                        SizedBox(height: 10),
                        IconTheme(
                          data: IconThemeData(
                            color: Colors.blue,
                            size: 20,
                          ),
                          child: StarDisplay(
                            value: (5).round(),
                          ),
                        ),
                      ],
                    )),
                  ),
                ),
                Positioned(
                    right: 20,
                    top: 70,
                    child: Icon(
                      Icons.more_horiz,
                      size: 45,
                    ))
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Container(
                color: Colors.grey.shade900,
                child: Text(
                  "Upcoming Movies",
                  style: heading.copyWith(
                    color: Colors.white.withOpacity(.0),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  for (var i = 0; i < 10; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 200,
                        width: 130,
                        color: Colors.grey.shade900,
                      ),
                    )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
              child: Container(
                color: Colors.grey.shade900,
                child: Text(
                  "Upcoming Movies",
                  style: heading.copyWith(
                    color: Colors.white.withOpacity(.0),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 12),
                  for (var i = 0; i < 10; i++)
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 200,
                        width: 130,
                        color: Colors.grey.shade900,
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
