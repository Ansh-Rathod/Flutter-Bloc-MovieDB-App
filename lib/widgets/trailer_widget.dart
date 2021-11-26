import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviedb/animation.dart';
import 'package:moviedb/constants.dart';
import 'package:moviedb/models/movie_model.dart';
import 'package:moviedb/widgets/video_player.dart';

class TrailersWidget extends StatelessWidget {
  const TrailersWidget({
    Key? key,
    required this.textColor,
    required this.trailers,
    required this.backdrops,
    required this.backdrop,
  }) : super(key: key);

  final Color textColor;
  final List<TrailerModel> trailers;
  final List<ImageBackdrop> backdrops;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DelayedDisplay(
            delay: Duration(microseconds: 1000),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child:
                  Text("Trailers", style: heading.copyWith(color: textColor)),
            ),
          ),
          DelayedDisplay(
            delay: Duration(microseconds: 1100),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < trailers.length; i++)
                    if (trailers[i].site == 'YouTube')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => VideoPlayer(
                                  id: trailers[i].key,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            constraints: BoxConstraints(minHeight: 150),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      child: CachedNetworkImage(
                                        imageUrl: backdrops.isNotEmpty
                                            ? backdrops[Random()
                                                    .nextInt(backdrops.length)]
                                                .image
                                            : backdrop,
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 180,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.play_arrow,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 200,
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    trailers[i].name,
                                    maxLines: 2,
                                    style: normalText.copyWith(
                                        color: textColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
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
    );
  }
}
