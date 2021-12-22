import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../animation.dart';
import '../constants.dart';
import '../models/movie_model.dart';
import 'video_player.dart';

class TrailersWidget extends StatelessWidget {
  const TrailersWidget({
    Key? key,
    required this.trailers,
    required this.backdrops,
    required this.backdrop,
  }) : super(key: key);

  final List<TrailerModel> trailers;
  final List<ImageBackdrop> backdrops;
  final String backdrop;

  @override
  Widget build(BuildContext context) {
    return DelayedDisplay(
      delay: const Duration(microseconds: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Trailers",
              style: heading.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                for (var i = 0; i < trailers.length; i++)
                  if (trailers[i].site == 'YouTube')
                    Padding(
                      padding: const EdgeInsets.all(16.0),
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Stack(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.grey.shade900,
                                        boxShadow: kElevationToShadow[8],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: CachedNetworkImage(
                                          imageUrl: backdrops.isNotEmpty
                                              ? backdrops[0].image
                                              : backdrop,
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 120,
                                    width: 200,
                                    child: Center(
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(.8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              alignment: Alignment.bottomLeft,
                              width: 200,
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                trailers[i].name,
                                maxLines: 2,
                                style: normalText.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
