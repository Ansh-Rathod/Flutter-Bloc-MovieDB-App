import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/widgets/star_icon_display.dart';
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
                  child: Container(
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
                      height: 300)),
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
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 5.0),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 20.0,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
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
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade900,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      )
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
                          decoration: BoxDecoration(
                            color: Colors.grey.shade900,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 10),
                        Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                            ),
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
