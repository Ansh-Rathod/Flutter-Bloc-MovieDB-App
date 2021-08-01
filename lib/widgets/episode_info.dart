import 'package:amd/models/season_info.dart';
import 'package:amd/widgets/star_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../themes.dart';
import 'castList.dart';

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
